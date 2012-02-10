! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.sequences arrays kernel math tools.test ;
IN: addenda.sequences.tests

[ { { 5 1 } { 3 3 } } ] [
    { 6 5 4 3 2 } V{ 0 1 2 3 4 5 } [ [ 2array ] [ * ] 2bi odd? ] 2filter
] unit-test

[ { 2 3 2 1 } ] [
    { 1 2 3 2 1 } { 3 2 } find-tail
] unit-test

[ { 3 2 1 } ] [
    { 1 2 3 2 1 } { 3 2 } find-tail*
] unit-test
