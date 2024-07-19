#!/usr/bin/env perl

use v5.40;

use Cpanel::JSON::XS ();
use Perl::Critic ();
use Perl::Critic::Utils::POD qw<get_raw_pod_section_for_module>;
use Path::Tiny qw<path>;
use Pod::Markdown ();

run(@ARGV) unless caller;

sub run ($submit_dir, $output_dir) {
    my $critic     = Perl::Critic->new;
    my @violations = map { $critic->critique($_) } module_file_paths( path($submit_dir)->child('lib') );

    my $json = Cpanel::JSON::XS->new->canonical->pretty->utf8->indent_length(2);
    return path($output_dir)
        ->child('analysis.json')
        ->spew_utf8( $json->encode( analyzer_object(\@violations, $submit_dir) ) );
}

sub module_file_paths ($path) {
    return map { __SUB__->($_) } $path->children if $path->is_dir;
    return $path->stringify if substr($path->basename, -3) eq '.pm';
    return;
}

sub pod_to_markdown_description ($module) {
    my $parser = Pod::Markdown->new;
    $parser->output_string(\my $md);
    $parser->parse_string_document(get_raw_pod_section_for_module $module, 'DESCRIPTION');
    return trim($md =~ s/.*DESCRIPTION$//mr);
}

sub analyzer_object ($violations, $submit_dir) {
    return {
        comments => [
            map { sub ($obj) {
                {
                    comment => 'perl5.general.perlcritic',
                    params  => {
                        (map { $_ => $obj->$_ } qw<description line_number policy>),
                        diagnostics => pod_to_markdown_description($obj->policy),
                        filename    => $obj->filename =~ s{^$submit_dir/}{}r,
                    },
                    type => 'actionable',
                }
            }->($_) } $violations->@*
        ],
    };
}
