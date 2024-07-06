#!/usr/bin/env perl

use v5.40;

use Cpanel::JSON::XS ();
use Perl::Critic ();
use Path::Tiny qw<path>;

run(@ARGV) unless caller;

sub run ($slug, $submit_dir, $output_dir) {
    my $json = Cpanel::JSON::XS->new->canonical->pretty->utf8->indent_length(2);
    my $critic = Perl::Critic->new;
    my @violations = map { $critic->critique($_) } module_files( path($submit_dir)->child('lib') );

    return path($output_dir)->child('analysis.json')->spew_utf8($json->encode({
        comments => [
            map { sub ($obj) {
                {
                    comment => 'perl5.general.perlcritic',
                    params  => { map { $_ => $obj->$_ } qw<description diagnostics filename line_number policy> },
                    type    => 'actionable',
                }
            }->($_) } @violations
        ],
    }));
}

sub module_files ($path) {
    if ($path->is_dir) {
        return map { module_files($_) } $path->children;
    }
    elsif (substr($path->basename, -3) eq '.pm') {
        return $path;
    }

    return;
}
