! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: arrays kernel math namespaces om.conversions sequences tools.test ;
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

[ { "C3" "C+3" "C#3" "D_3" "D3" "D+3" "Eb3" "E_3" "E3" "E+3" "F3" "F+3"
    "F#3" "G_3" "G3" "G+3" "G#3" "A_3" "A3" "A+3" "Bb3" "B_3" "B3" "B+3" } ] [
    24 iota [ 50 * 6000 + f mc->n1 ] map
] unit-test

[ { "do3+1" "do+3+1" "do#3+1" "re_3+1" "re3+1" "re+3+1" "mib3+1" "mi_3+1"
    "mi3+1" "mi+3+1" "fa3+1" "fa+3+1" "fa#3+1" "sol_3+1" "sol3+1" "sol+3+1"
    "sol#3+1" "la_3+1" "la3+1" "la+3+1" "sib3+1" "si_3+1" "si3+1" "si+3+1" } ] [
        24 iota +ascii-note-do-scale+ get 1array
        [ [ 50 * 6001 + ] dip mc->n1 ] curry map
] unit-test

[ 1000 ] [
    1 60 beats->ms
] unit-test

[ 83 ] [
    1/8 90 beats->ms
] unit-test
