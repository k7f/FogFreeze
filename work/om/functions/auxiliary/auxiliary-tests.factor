! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: om.functions.auxiliary om.kernel tools.test ;
IN: om.functions.auxiliary.tests

[ { { 69 5 } { 100 8 } } ] [
    70 { { 0 0 } { 41 3 } { 50 6 } { 69 5 } { 100 8 } } x-around
] unit-test

[ V{ { 0 0 } { 0 0 } } ] [
    -1 V{ { 0 0 } { 41 3 } { 50 6 } { 69 5 } { 100 8 } } x-around
] unit-test

[ { V{ 100 8 } V{ 100 8 } } ] [
    101 { V{ 0 0 } V{ 41 3 } V{ 50 6 } V{ 69 5 } V{ 100 8 } } x-around
] unit-test

[ { { { 41 3 } { 50 6 } } { { 50 6 } { 69 5 } } { { 69 5 } { 100 8 } } } ] [
    5.5 { { 0 0 } { 41 3 } { 50 6 } { 69 5 } { 100 8 } } y-around
] unit-test

[ -1 ] [
    0 2 2 0 3 linear-interpol
] unit-test

[ 1 ] [
    { { 0 2 } { 2 0 } } 1 linear-interpol*
] unit-test

[ { 0 75/82 1+34/41 2+61/82 6 5+13/38 5+18/31 6+49/62 8 } ] [
    { 0 41 50 69 100 } { 0 3 6 5 8 } 12+1/2 interpolate
] unit-test

[ 6 ] [
    { 0 41 50 69 100 } { 0 3 6 5 8 } 0 100 1 interpole
] unit-test

[ { 0 1.83 6.0 5.58 8.0 } ] [
    { 0 41 50 69 100 } { 0 3 6 5 8 } 0 100 5 interpole 2 om-round
] unit-test

[ { 4 5.0 } ] [
    { 1 2 3 } { 4 5 6 } 0 2 3 interpole
] unit-test

[ { 5.0 6.0 } ] [
    { 1 2 3 } { 4 5 6 } 2 4 3 interpole
] unit-test
