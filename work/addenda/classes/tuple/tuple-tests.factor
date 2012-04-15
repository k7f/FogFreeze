! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.classes.tuple kernel tools.test ;
IN: addenda.classes.tuple.tests

TUPLE: acbd a c b d ;

[ { { "a" f } { "c" f } { "b" f } { "d" f } } ] [
    acbd new tuple>assoc
] unit-test

[ T{ acbd f f f t f } ] [
    acbd new { { "b" t } } supply-defaults
] unit-test

TUPLE: base x ;
TUPLE: derived < base y ;

[ T{ derived f "b" "d" } ] [
    "b" base boa { "d" } derived new-derived
] unit-test
