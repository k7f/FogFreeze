! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: math.ranges om.series tools.test ;
IN: om.series.tests

[ { 700 200 } ] [
    { 6000 6700 6900 } x->dx
] unit-test

[ { 1000 200 800 3000 } ] [
    { 0 1000 1200 2000 5000 } x->dx
] unit-test

[ { 6000 6700 6900 } ] [
    6000 { 700 200 } dx->x
] unit-test

[ { 0 1000 1200 2000 5000 } ] [
    0 { 1000 200 800 3000 } dx->x
] unit-test

[ { 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0 } ] [
    1 5 0.5 f arithm-ser
] unit-test

[ { 0 1 1 2 3 5 8 } ] [
    0 1 10 f fibo-ser
] unit-test

[ { 1 3 4 7 } ] [
    1 3 10 f fibo-ser
] unit-test

[ { 2 3 5 8 } ] [
    0 1 30 { 3 6 } fibo-ser
] unit-test

[ { 7 11 18 29 } ] [
    1 3 30 { 3 6 } fibo-ser
] unit-test

[ { 1 3 9 27 } ] [
    1 3 60 f geometric-ser
] unit-test

[ { 2 6 18 54 } ] [
    2 3 60 f geometric-ser
] unit-test
