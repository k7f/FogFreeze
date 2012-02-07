! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.sequences tools.test ;
IN: addenda.sequences.tests

[ { 2 3 2 1 } ] [
    { 1 2 3 2 1 } { 3 2 } find-tail
] unit-test

[ { 3 2 1 } ] [
    { 1 2 3 2 1 } { 3 2 } find-tail*
] unit-test
