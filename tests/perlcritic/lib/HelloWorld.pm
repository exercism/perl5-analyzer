package HelloWorld;
package GoodbyeMars;

use feature qw<signatures>;

sub hello () {
    grep {$_} (1..2);
    'Goodbye, Mars!';
}
