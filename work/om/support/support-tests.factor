! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: om.support tools.test ;
IN: om.support.tests

[ { 2 3 2 1 } ] [
    { 1 2 3 2 1 } { 3 2 } find-tail
] unit-test

[ { 3 2 1 } ] [
    { 1 2 3 2 1 } { 3 2 } find-tail*
] unit-test

[ { 123 "test" T{ cl-symbol { name "test" } } } ] [
    '( 123 "test" test )
] unit-test
