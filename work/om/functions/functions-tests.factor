! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: om.bpf om.graphics om.functions sequences tools.test ;
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

[ T{ bpf f V{ T{ om-point f 0. 0. } T{ om-point f .5 1. } } f f } { 0. .5 } { 0. 1. } ] [
    0 0 1 2 linear-fun 2 f om-sample
] unit-test

[
    T{ bpf f V{ T{ om-point f 0. 0. } T{ om-point f .5 1. } T{ om-point f 1. 2. } } f f }
    { 0. .5 1. } { 0. 1. 2. }
] [
    0 0 1 2 linear-fun .5 f om-sample
] unit-test

[
    T{ bpf f V{ T{ om-point f 1. 2. } T{ om-point f 1.5 3. } T{ om-point f 2. 4. } } f f }
    { 1. 1.5 2. } { 2. 3. 4. }
] [
    0 0 1 2 linear-fun .5 { 1 2 } om-sample
] unit-test
