! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors arrays kernel om.bpf om.graphics tools.test ;
IN: om.bpf.tests

[ { } ] [
    0 <internal-bpf> points>> underlying>>
] unit-test

[ { T{ om-point f 0 0 } } ] [
    1 <internal-bpf> points>> underlying>>
] unit-test

[ { T{ om-point f 0 0 } T{ om-point f 100 100 } } ] [
    2 <internal-bpf> points>> underlying>>
] unit-test

[ { T{ om-point f 0 0 } T{ om-point f 100 100 } 0 } ] [
    3 <internal-bpf> points>> underlying>>
] unit-test

[ { T{ om-point f 0 0 } T{ om-point f 100 100 } 0 } ] [
    3 <bpf> points>> underlying>>
] unit-test

[ { } ] [
    0 <bpf-lib> bpfs>> underlying>>
] unit-test

[ { T{ bpf f V{ T{ om-point f 0 0 } T{ om-point f 100 100 } } f f } } ] [
    1 <bpf-lib> bpfs>> underlying>>
] unit-test

[ { { 0 0 } { 100 100 } } ] [
    3 <bpf> point-pairs
] unit-test

[ { T{ om-point f 2 1 } T{ om-point f 4 3 } } ] [
    4 3 2 1 [ <om-point> ] 2bi@ 2array
    2 <bpf> [ cons-bpf ] keep points>> underlying>>
] unit-test

[ { T{ om-point f 1 3 } T{ om-point f 2 3 } } ] [
    { 1 2 } 3 f simple-bpf-from-list points>> underlying>>
] unit-test

[ { T{ om-point f 0 2 } T{ om-point f 1 3 } } ] [
    1 { 2 3 } f simple-bpf-from-list points>> underlying>>
] unit-test

[ { } ] [
    f { 3 4 } f simple-bpf-from-list points>> underlying>>
] unit-test

[ { T{ om-point f 1 3 } T{ om-point f 2 4 } } ] [
    { 1 2 } { 3 4 } f simple-bpf-from-list points>> underlying>>
] unit-test

[ { T{ om-point f 1 4 }
    T{ om-point f 2 5 }
    T{ om-point f 3 6 }
    T{ om-point f 4 7 }
    T{ om-point f 5 8 } } ] [
    { 1 2 3 } { 4 5 6 7 8 } f simple-bpf-from-list points>> underlying>>
] unit-test

[ { T{ om-point f 1 6 }
    T{ om-point f 2 7 }
    T{ om-point f 3 8 }
    T{ om-point f 4 9 }
    T{ om-point f 5 10 } } ] [
    { 1 2 3 4 5 } { 6 7 8 } f simple-bpf-from-list points>> underlying>>
] unit-test
