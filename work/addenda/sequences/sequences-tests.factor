! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.sequences arrays kernel math sequences tools.test ;
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

[ { 3 4 5 6 7 } ] [
    10 iota 3 7 trim-range-slice >array
] unit-test

[ { 3 } ] [
    10 iota 3 3 trim-range-slice >array
] unit-test

[ f ] [
    10 iota 7 3 trim-range-slice
] unit-test

[ f ] [
    10 iota 10 11 trim-range-slice
] unit-test

[ { { { 1 2 3 } 0 } { { 2 3 } 1 } { { 3 } 3 } { { } 6 } } ] [
    { 1 2 3 4 } [ { 1 2 3 } 0 rot [ < ] curry [ + ] reduce-head 2array ] map
] unit-test

[ { { { } 6 } { { 1 } 5 } { { 1 2 } 3 } { { 1 2 3 } 0 } } ] [
    { 1 2 3 4 } [ { 1 2 3 } 0 rot [ >= ] curry [ + ] reduce-tail 2array ] map
] unit-test
