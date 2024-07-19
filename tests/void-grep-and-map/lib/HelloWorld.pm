package HelloWorld;

use v5.40;

sub hello () {
    grep {$_} 1..5;
    map {$_} 1..5;
    return 'Goodbye, Mars!';
}
