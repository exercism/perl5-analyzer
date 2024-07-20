package HelloWorld;

use v5.40;

use Exporter qw<import>;
our @EXPORT = qw<hello>;

sub hello () {
    return 'Goodbye, Mars!';
}
