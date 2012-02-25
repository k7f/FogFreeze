! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: arrays kernel math om.support sequences tools.test ;
IN: om.support.tests

[ "x" ] [
    f unpack1 [ "x" ] unless*
] unit-test

[ "a" ] [
    "a" unpack1 [ "x" ] unless*
] unit-test

[ "a" ] [
    { "a" "b" } unpack1 [ "x" ] unless*
] unit-test

[ "x" "y" ] [
    f "x" unpack2 [ "y" ] unless*
] unit-test

[ "a" "y" ] [
    "a" "x" unpack2 [ "y" ] unless*
] unit-test

[ "a" "b" ] [
    { "a" "b" } "x" unpack2 [ "y" ] unless*
] unit-test

[ "x" "y" "z" ] [
    f "x" "y" unpack3 [ "z" ] unless*
] unit-test

[ "a" "y" "z" ] [
    "a" "x" "y" unpack3 [ "z" ] unless*
] unit-test

[ "a" "b" "z" ] [
    { "a" "b" } "x" "y" unpack3 [ "z" ] unless*
] unit-test

[ "a" "b" "c" ] [
    { "a" "b" "c" } "x" "y" unpack3 [ "z" ] unless*
] unit-test

[ t ] [
    1 2 f [ < ] unpack-test&key call
] unit-test

[ f ] [
    1 2 [ > ] [ < ] unpack-test&key call
] unit-test

[ t ] [
    1 2 f [ < ] at-test&key call
] unit-test

[ f ] [
    1 2 { { :test [ > ] } } [ < ] at-test&key call
] unit-test

[ f ] [
    1 2 { { :key [ neg ] } } [ < ] at-test&key call
] unit-test

[ { { { 2 2 } { -3 -1 } } { { -4 2 } { 3 -1 } } } ] [
    { 8 -10 } { 3 -3 } [ cl-floor 2array ] cartesian-map
] unit-test

[ { { { 3 -1 } { -3 -1 } } { { -3 -1 } { 3 -1 } } } ] [
    { 8 -10 } { 3 -3 } [ cl-round 2array ] cartesian-map
] unit-test

[ { { { 3 -1 } { -2 2 } } { { -3 -1 } { 4 2 } } } ] [
    { 8 -10 } { 3 -3 } [ cl-ceiling 2array ] cartesian-map
] unit-test

[ { { { 2 2 } { -2 2 } } { { -3 -1 } { 3 -1 } } } ] [
    { 8 -10 } { 3 -3 } [ cl-truncate 2array ] cartesian-map
] unit-test
