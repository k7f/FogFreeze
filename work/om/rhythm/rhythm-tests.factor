! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: kernel math om.rhythm om.rhythm.meter tools.test ;
IN: om.rhythm.tests

[ T{ rhythm f 1 { 1/4 1/4 1/4 1/4 } } ] [
    f { 1/4 1/4 1/4 1/4 } <rhythm>
] unit-test

[ T{ rhythm f 3/4 { 1/4 1/4 1/4 } } ] [
    f { 1/4 1/4 1/4 } <rhythm>
] unit-test

[ T{ rhythm f 1 { 1 1 1 1 } } ] [
    1 { 1 1 1 1 } <rhythm>
] unit-test

[ T{ rhythm f T{ meter f 4 4 } { 1 1 1 1 } } ] [
    { 4 4 } { 1 1 1 1 } <rhythm>
] unit-test

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
    { 1 2 3 4 } 4 absolute-rhythm
] unit-test

[ T{ rhythm f 1 { 1. 1 1 } } ] [
    { 2 3 } 3 absolute-rhythm
] unit-test

[ T{ rhythm f 1 { 1. 2 1 } } ] [
    { 1+1/4 1+3/4 } 1 absolute-rhythm
] unit-test

[ 4 ] [
    { 1 } 4 absolute-rhythm-element
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

[ { 1 T{ rhythm f 1 { 1 T{ rhythm f 1 { 4 1 } } 3 } } 2 } ] [
    { 1 T{ rhythm f 1 { 1 T{ rhythm f 1 { 1 2. 1. 1 } } 1 1. 1. } } 1 1. } fuse-notes-deep
] unit-test

[ { T{ rhythm f 1 { -1 T{ rhythm f 1 { 1 -3 1 } } -3 } } } ] [
    { T{ rhythm f 1 { -1 T{ rhythm f 1 { 1 -2 -1 1 } } -1 -1 -1 } } } fuse-rests-deep
] unit-test

[ { T{ rhythm f 1 { -2 -1 -1 } } } ] [
    { T{ rhythm f 1 { -1 -1 T{ rhythm f 1 { -2 -1 } } -1 } } } fuse-rests-deep
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

[ T{ rhythm f f { T{ rhythm f T{ meter f 4 4 } { 4 } } } } ] [
    { 1 } { { 4 4 } } zip-measures
] unit-test

[ T{ rhythm f f { T{ rhythm f T{ meter f 4 4 } { 1 1 1 1 } } } } ] [
    { 1/4 1/4 1/4 1/4 } { { 4 4 } } zip-measures
] unit-test

[ T{ rhythm f f { T{ rhythm f T{ meter f 4 4 } { -1 1 -1 1 } } } } ] [
    { -1/4 1/4 -1/4 1/4 } { { 4 4 } } zip-measures
] unit-test

[ T{ rhythm f f
     { T{ rhythm f T{ meter f 3 4 } { 1 1 1 } }
       T{ rhythm f T{ meter f 3 4 } { 3. } } } } ] [
    { 1/4 1/4 4/4 } { { 3 4 } { 3 4 } } zip-measures
] unit-test

[ T{ rhythm f T{ meter f 4 4 } { T{ rhythm f 1 { 2 } } 2 4 } } ] [
    T{ rhythm f T{ meter f 4 4 } { T{ rhythm f 1 { 1 } } 1 2 } } [ 2 * ] map-rhythm
] unit-test

[ T{ rhythm f T{ meter f 4 4 } { T{ rhythm f 1 { 2 } } 2 4 } } ] [
    T{ rhythm f T{ meter f 4 4 } { T{ rhythm f 1 { 1 } } 1 2 } } [ 2 * ] map-rhythm!
] unit-test

[ f ] [
    T{ rhythm f T{ meter f 4 4 } { 1 } } dup [ ] map-rhythm eq?
] unit-test

[ t ] [
    T{ rhythm f T{ meter f 4 4 } { 1 } } dup [ ] map-rhythm! eq?
] unit-test
