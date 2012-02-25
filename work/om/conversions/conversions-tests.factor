! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: om.conversions tools.test ;
IN: om.conversions.tests

[ 6100 ] [
    6050 2 f approx-m
] unit-test

[ 5650 ] [
    5700 4 30 approx-m
] unit-test

[ { 6000 6200 } ] [
    { 6050 6100 } 1 f approx-m
] unit-test

[ { 220. 880. } ] [
    { 5700 8100 } mc->f
] unit-test

[ 5650 ] [
    220. { 4 70 } f->mc
] unit-test

[ { 5700 8100 } ] [
    { 220. 880. } f f->mc
] unit-test

[ { 5700 8100 } ] [
    { 220. 880. } { 4 20 } f->mc
] unit-test

[ 1000 ] [
    1 60 beats->ms
] unit-test

[ 83 ] [
    1/8 90 beats->ms
] unit-test
