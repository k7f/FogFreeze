! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: om.rhythm tools.test ;
IN: om.rhythm.tests

[ T{ rhythm f 1 { 1 1 1 1 } } ] [
    { 1 2 3 4 5 } onsets>rhythm
] unit-test

[ T{ rhythm f 1 { 1. 1 -1 } } ] [
    { 2 -3 4 } onsets>rhythm
] unit-test

[ T{ rhythm f 1 { T{ rhythm f 2 { 1 1 1 } } -1 1 } } ] [
    { 1 3 5 -7 10 13 } onsets>rhythm
] unit-test

[ T{ rhythm f 1 { 1 -1 T{ rhythm f 2 { 1 1 1 } } } } ] [
    { 1 -4 7 9 11 13 } onsets>rhythm
] unit-test

[ T{ rhythm f 1 { -1 T{ rhythm f 2 { 1 1 1 } } 1 } } ] [
    { -1 4 6 8 10 13 } onsets>rhythm
] unit-test

[ T{ rhythm f 1 { 1. T{ rhythm f 2 { 1 1 1 } } -1 } } ] [
    { 4 6 8 -10 13 } onsets>rhythm
] unit-test

[ T{ rhythm f 1 { 1 1 T{ rhythm f 2 { 2 1 } } } } ] [
    { 1 4 7 11 13 } onsets>rhythm
] unit-test

[ T{ rhythm f 1 { T{ rhythm f 2 { 2 1 } } 1 1 } } ] [
    { 1 5 7 10 13 } onsets>rhythm
] unit-test

[ T{ rhythm f 1 { T{ rhythm f 2 { 1 2 } } 1 1 } } ] [
    { 1 3 7 10 13 } onsets>rhythm
] unit-test

[ T{ rhythm f 1 { 1 1 T{ rhythm f 2 { 1 2 } } } } ] [
    { 1 4 7 9 13 } onsets>rhythm
] unit-test

[ T{ rhythm f 1 { 1 T{ rhythm f 1 { 1 1 1 } } } } ] [
    { 1 4 5 6 7 } onsets>rhythm
] unit-test

[ T{ rhythm f 1 { 1. T{ rhythm f 1 { 1 1 1 } } } } ] [
    { 4 5 6 7 } onsets>rhythm
] unit-test

[ T{ rhythm f 1 { T{ rhythm f 1 { 1 1 1 } } 1 } } ] [
    { 1 2 3 4 7 } onsets>rhythm
] unit-test

[ T{ rhythm f 1 { 1 1 1 1 } } ] [
    { 1 2 3 4 } 4 <rhythm>
] unit-test

[ T{ rhythm f 1 { 1. 1 1 } } ] [
    { 2 3 } 3 <rhythm>
] unit-test

[ T{ rhythm f 1 { 1. 2 1 } } ] [
    { 1+1/4 1+3/4 } 1 <rhythm>
] unit-test

[ 4 ] [
    { 1 } 4 <rhythm-element>
] unit-test

[ f ] [
    f fuse-rests-and-ties
] unit-test

[ { 1 -2 } ] [
    { 1 -1 1. } fuse-rests-and-ties
] unit-test

[ { 2 -1 } ] [
    { 1 1. -1 } fuse-rests-and-ties
] unit-test

[ t ] [
    { 1 } 4 4 <measure> measure?
] unit-test

[ T{ rhythm f T{ meter f 4 4 } { 4 } } ] [
    { 1 } 4 4 <measure>
] unit-test

[ T{ rhythm f T{ meter f 4 4 } { 1 1 1 1 } } ] [
    { 1 1+1/4 1+2/4 1+3/4 } 4 4 <measure>
] unit-test

[ T{ rhythm f T{ meter f 4 4 } { 1. 2 1 } } ] [
    { 1+1/4 1+3/4 } 4 4 <measure>
] unit-test
