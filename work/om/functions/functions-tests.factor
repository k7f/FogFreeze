! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: om.functions sequences tools.test ;
IN: om.functions.tests

[ { 2 1 0 -1 -2 } ] [
    { -2 -1 0 1 2 } 0 0 1 -1 linear-fun map
] unit-test

[ { 48+1/2 59+1/2 74+167/1000 } ] [
    { { 0 0 } { 41 3 } { 50 6 } { 69 5 } { 100 8 } } 5+1/2 3 y-transfer
] unit-test

[ 5+97/1000 ] [
    { { 0 0 } { 41 3 } { 50 6 } { 69 5 } { 100 8 } } 70 3 x-transfer
] unit-test

[ { 21/41 5 } ] [
    { { 0 0 } { 41 3 } { 50 6 } { 69 5 } { 100 8 } } { 7 47 } f x-transfer
] unit-test
