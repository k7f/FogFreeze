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
    { 5700 8100 } midicents>hz
] unit-test

[ 5650 ] [
    220. { 4 70 } hz>midicents
] unit-test

[ { 5700 8100 } ] [
    { 220. 880. } f hz>midicents
] unit-test

[ { 5700 8100 } ] [
    { 220. 880. } { 4 20 } hz>midicents
] unit-test

[ { "C3" "C+3" "C#3" "D_3" "D3" "D+3" "Eb3" "E_3" "E3" "E+3" "F3" "F+3"
    "F#3" "G_3" "G3" "G+3" "G#3" "A_3" "A3" "A+3" "Bb3" "B_3" "B3" "B+3" } ] [
    24 iota [ 50 * 6000 + f midicents>string ] map
] unit-test

[ { "do3+1" "do+3+1" "do#3+1" "re_3+1" "re3+1" "re+3+1" "mib3+1" "mi_3+1"
    "mi3+1" "mi+3+1" "fa3+1" "fa+3+1" "fa#3+1" "sol_3+1" "sol3+1" "sol+3+1"
    "sol#3+1" "la_3+1" "la3+1" "la+3+1" "sib3+1" "si_3+1" "si3+1" "si+3+1" } ] [
        24 iota +ascii-note-do-scale+ get 1array
        [ [ 50 * 6001 + ] dip midicents>string ] curry map
] unit-test

[ { "C3" "C+3" "C#3" "D_3" "D3" "D+3" "Eb3" "E_3" "E3" "E+3" "F3" "F+3"
    "F#3" "G_3" "G3" "G+3" "G#3" "A_3" "A3" "A+3" "Bb3" "B_3" "B3" "B+3" } ] [
        24 iota [ 50 * 6000 + ] map midicents>string*
] unit-test

[ { 6000 6050 6100 6150 6200 6250 6300 6350 6400 6450 6500 6550
    6600 6650 6700 6750 6800 6850 6900 6950 7000 7050 7100 7150 } ] [
    { "C3" "C+3" "C#3" "D_3" "D3" "D+3" "Eb3" "E_3" "E3" "E+3" "F3" "F+3"
      "F#3" "G_3" "G3" "G+3" "G#3" "A_3" "A3" "A+3" "Bb3" "B_3" "B3" "B+3"
    } string>midicents*
] unit-test

[ { "6m-2" "4A" "3M+1" } ] [
    { -1600 600 1600 } [ interval>string ] map
] unit-test

[ { { "6m-2" "4A" } "3M+1" } ] [
    { { -1600 600 } 1600 } interval>string*
] unit-test

[ { -1600 600 1600 } ] [
    { "6m-2" "4A" "3M+1" } [ string>interval ] map
] unit-test

[ { -1600 { 600 1600 } } ] [
    { "6m-2" { "4A" "3M+1" } } string>interval*
] unit-test

[ { 0 100 200 300 400 500 600 700 800 900 1000 1100 } ] [
    { "1" "2m" "2M" "3m" "3M" "4" "4A" "5" "6m" "6M" "7m" "7M" } string>interval*
] unit-test

[ 1000 ] [
    1 60 beats>ms
] unit-test

[ 83 ] [
    1/8 90 beats>ms
] unit-test
