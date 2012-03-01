! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: arrays kernel math om.trees.onsets sequences tools.test ;
IN: om.trees.onsets.tests

[ { 1 -2 } ] [
    { 4 -5 7 } onsets>increments
] unit-test

[ { 4 -5 7 } ] [
    4 { 1 -2 } increments>onsets
] unit-test

[ { { 8 -9 11 } { 5 -6 8 } { 2 -3 5 } { -1 0 2 } } ] [
    { 4 -5 7 } { -3 0 3 6 } [ global>local ] with map
] unit-test

[ { f 2 3 3 } ] [
    4 iota { 0 3 3.5 5 } [ last-before ] with map
] unit-test

[ { 3 4 5 6 7 } ] [
    10 iota 3 7 trim-between >array
] unit-test

[ f ] [
    { -1 3 -5 } 6 10 trim-between
] unit-test

[ { -2 3 -5 } ] [
    { -1 3 -5 } 2 6 trim-between*
] unit-test

[ { -6 } ] [
    { -1 3 -5 } 6 10 trim-between*
] unit-test
