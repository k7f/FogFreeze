! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: om.functions.auxiliary tools.test ;
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
