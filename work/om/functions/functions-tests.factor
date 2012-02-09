! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: om.functions sequences tools.test ;
IN: om.functions.tests

[ { 2 1 0 -1 -2 } ] [
    { -2 -1 0 1 2 } 0 0 1 -1 linear-fun map
] unit-test
