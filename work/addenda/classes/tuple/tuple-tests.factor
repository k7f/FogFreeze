! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.classes.tuple continuations kernel tools.test ;
IN: addenda.classes.tuple.tests

TUPLE: base x ;
TUPLE: derived < base y ;

[ T{ derived f "b" "d" } ] [
    "b" base boa f "d" derived boa clone-as
] unit-test

[ T{ not-a-subclass f T{ derived f f "d" } T{ base f "b" } derived base } ] [
    "b" base boa f "d" derived boa swap
    [ clone-as ] [ 2nip ] recover
] unit-test

[ T{ derived f "b" "d" } ] [
    "b" base boa { "d" } derived clone-as*
] unit-test

[ T{ not-a-subclass f T{ derived f "b" "d" } f derived base } ] [
    "b" "d" derived boa { "x" } base
    [ clone-as* ] [ [ 3drop ] dip ] recover
] unit-test

TUPLE: acbd a c b d ;

[ { { "a" f } { "c" f } { "b" f } { "d" f } } ] [
    acbd new tuple>assoc
] unit-test

[ T{ acbd f f f t f } ] [
    acbd new { { "b" t } } supply-defaults
] unit-test
