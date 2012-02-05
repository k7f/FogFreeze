! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: kernel math.functions om.sets tools.test ;
IN: om.sets.tests

[ { 1 2 3 4 5 6 7 8 } ] [
    { 1 2 3 4 5 } { 4 5 6 7 8 } f f x-union
] unit-test

[ { 2 3 5 7 } ] [
    { 2 3 4 5 } { 4 5 6 7 8 } [ swap divisor? ] f x-union
] unit-test

[ { 2 3 5 7 11 13 } ] [
    { 2 3 4 5 } { 4 5 6 7 8 } [ swap divisor? ] { { 9 10 } { 11 12 } { 13 } } x-union
] unit-test

[ { 4 5 } ] [
    { 1 2 3 4 5 } { 4 5 6 7 8 } f f x-intersect
] unit-test

[ { 1 2 3 } ] [
    { 1 2 3 4 5 } { 4 5 6 7 8 } f f x-diff
] unit-test

[ { 1 2 3 6 7 8 } ] [
    { 1 2 3 4 5 } { 4 5 6 7 8 } f f x-xor
] unit-test

[ f ] [
    { 1 2 3 4 5 } { 4 5 6 7 8 } f included?
] unit-test

[ t ] [
    { 5 6 } { 4 5 6 7 8 } f included?
] unit-test

[ t ] [
    { 1 2 3 4 5 } { 4 5 6 7 8 } [ swap divisor? ] included?
] unit-test
