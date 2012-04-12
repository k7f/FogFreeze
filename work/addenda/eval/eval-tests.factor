! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.eval kernel prettyprint.custom sequences tools.test ;
IN: addenda.eval.tests

[ 3/4 t ] [
    "3/4" f ?eval-literal
] unit-test

[ 1+3/4 1+3/4 ] [
    "7/4" f ?eval-literal
] unit-test

[ { } t ] [
    "{ }" f ?eval-literal
] unit-test

[ { } { } ] [
    "{  }" f ?eval-literal
] unit-test

<<
TUPLE: expected ;
TUPLE: failed ;
SYNTAX: FAIL expected new suffix! ;
M: expected pprint* ( fail -- ) drop failed new pprint* ;
>>

[ T{ expected } f ] [
    "FAIL" { "addenda.eval.tests" } ?eval-literal
] unit-test
