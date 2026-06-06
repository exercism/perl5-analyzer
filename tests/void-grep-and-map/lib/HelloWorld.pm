package HelloWorld;

use v5.42;

sub hello () {
    grep {$_} 1..5;
    map {$_} 1..5;
    return 'Goodbye, Mars!';
}
