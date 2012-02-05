! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: kernel om.support tools.test ;
IN: om.support.tests

[ { 1 } ] [
    { 1 2 3 } { 2 3 4 } [ = ] diff*
] unit-test

[ { 1 4 } ] [
    { 1 2 3 } { 2 3 4 } symmetric-diff
] unit-test

[ { 1 4 } ] [
    { 1 2 3 } { 2 3 4 } [ = ] symmetric-diff*
] unit-test

[ { 2 3 2 1 } ] [
    { 1 2 3 2 1 } { 3 2 } find-tail
] unit-test

[ { 3 2 1 } ] [
    { 1 2 3 2 1 } { 3 2 } find-tail*
] unit-test

[ { 123 "test" T{ cl-symbol { name "test" } } } ] [
    '( 123 "test" test )
] unit-test

[ { 123 "test" T{ cl-symbol { name "test" } } { 123 "test" T{ cl-symbol { name "test" } } } } ] [
    '( 123 "test" test ( 123 "test" test ) )
] unit-test
