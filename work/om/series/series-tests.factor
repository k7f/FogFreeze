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
    1 5 0.5 { } arithm-ser
] unit-test
