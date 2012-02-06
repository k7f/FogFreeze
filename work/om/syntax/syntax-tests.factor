! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: om.support om.syntax tools.test ;
IN: om.syntax.tests

[ { 123 "test" T{ cl-symbol { name "test" } } } ] [
    '( 123 "test" test )
] unit-test

[ { 123 "test" T{ cl-symbol { name "test" } } { 123 "test" T{ cl-symbol { name "test" } } } } ] [
    '( 123 "test" test ( 123 "test" test ) )
] unit-test
