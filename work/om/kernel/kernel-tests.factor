! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: arrays math math.ranges om.kernel sequences tools.test ;
IN: om.kernel.tests

[ 5 ] [
    2 3 om+
] unit-test

[ { 5 6 } ] [
    2 { 3 4 } om+
] unit-test

[ { 4 6 } ] [
    { 1 2 } { 3 4 } om+
] unit-test

[ 6 ] [
    2 3 om*
] unit-test

[ { 6 8 } ] [
    2 { 3 4 } om*
] unit-test

[ { 3 8 } ] [
    { 1 2 } { 3 4 } om*
] unit-test

[ 3 ] [
    5 2 om-
] unit-test

[ { 3 1 } ] [
    5 { 2 4 } om-
] unit-test

[ { 3 2 } ] [
    { 5 4 } 2 om-
] unit-test

[ { 3 0 } ] [
    { 5 4 } { 2 4 } om-
] unit-test

[ 4 ] [
    8 2 om/
] unit-test

[ { 4 2 } ] [
    8 { 2 4 } om/
] unit-test

[ { 4 5/4 } ] [
    { 8 5 } { 2 4 } om/
] unit-test

[ 8 ] [
    2 3 om^
] unit-test

[ { 8 16 32 } ] [
    2 { 3 4 5 } om^
] unit-test

[ { 8 27 64 } ] [
    { 2 3 4 } 3 om^
] unit-test

[ { 4 27 256 } ] [
    { 2 3 4 } { 2 3 4 } om^
] unit-test

[ 54.59815 ] [
    4 om-e 6 om-round
] unit-test

[ { 20.085537 54.59815 } ] [
    { 3 4 } om-e 6 om-round
] unit-test

[ 1.0986123 ] [
    3 f om-log 7 om-round
] unit-test

[ 0.4771213 ] [
    3 10 om-log 7 om-round
] unit-test

[ { 1.0986123 1.3862944 } ] [
    { 3 4 } f om-log 7 om-round
] unit-test

[ { 0.4771213 0.60206 } ] [
    { 3 4 } 10 om-log 7 om-round
] unit-test

[ 4 ] [
    4.3 f om-round
] unit-test

[ { 4 5 7 } ] [
    { 4.3 5.0 6.8 } f om-round
] unit-test

[ { 4.31 5.17 6.81 } ] [
    { 4.308 5.167 6.809 } 2 om-round
] unit-test

[ { 2 3 3 } ] [
    { 4.308 5.167 6.809 } { 0 2 } om-round
] unit-test

[ { 2.2 2.6 3.4 } ] [
    { 4.308 5.167 6.809 } { 1 2 } om-round
] unit-test

[ 2 1.5 ] [
    5.5 2 om//
] unit-test

[ 5  0.5 ] [
    5.5 1 om//
] unit-test

[ { 2 3 } { 1.5 0 } ] [
    { 5.5 6 } 2 om//
] unit-test

[ { 2 1 } { 1.5 2.5 } ] [
    5.5 { 2 3 } om//
] unit-test

[ { 2 2 } { 1.5 0 } ] [
    { 5.5 6 } { 2 3 } om//
] unit-test

[ 3 ] [
    3 om-abs
] unit-test

[ 3 ] [
    -3 om-abs
] unit-test

[ { 3 4 1.5 6 } ] [
    { 3 -4 -1.5 6 } om-abs
] unit-test

[ 3 ] [
    3 4 om-min
] unit-test

[ { 1 2 3 3 } ] [
    3 { 1 2 3 4 } om-min
] unit-test

[ { 1 2 2 1 } ] [
    { 4 3 2 1 } { 1 2 3 4 } om-min
] unit-test

[ 4 ] [
    3 4 om-max
] unit-test

[ { 3 3 3 4 } ] [
    3 { 1 2 3 4 } om-max
] unit-test

[ { 4 3 3 4 } ] [
    { 4 3 2 1 } { 1 2 3 4 } om-max
] unit-test

[ 1 ] [
    { 2 3 1 4 } list-min
] unit-test

[ 1 ] [
    { 2 3 1 4 } list-min*
] unit-test

[ 4 ] [
    { 2 4 1 3 } list-max
] unit-test

[ 4 ] [
    { 2 4 1 3 } list-max*
] unit-test

[ 1 ] [
    { { 2 { 1 } } 4 { 3 } } f tree-min
] unit-test

[ 4 ] [
    { { 2 { 1 } } 4 { 3 } } f tree-max
] unit-test

[ 0 ] [
    { { 2 { 1 } } 4 { 3 } } 0 tree-min
] unit-test

[ 5 ] [
    { { 2 { 1 } } 4 { 3 } } 5 tree-max
] unit-test

[ 2.5 ] [
    { 1 2 3 4 } f om-mean
] unit-test

[ 2.0 ] [
    { 1 2 3 4 } { 3 2 1 1 } om-mean
] unit-test

[ 50 ] [
    0 100 5 { 0 10 } om-scale
] unit-test

[ { 0 20 50 } ] [
    0 100 { 0 2 5 } { 0 10 } om-scale
] unit-test

[ { 0 40 100 } ] [
    0 100 { 0 2 5 } f om-scale
] unit-test

[ { 6 9 15 } ] [
    { 2 3 5 } 30 g-scaling/sum
] unit-test

[ { { 6 9 15 } { 5 15 30 } } ] [
    { { 2 3 5 } { 1 3 6 } } { 30 50 } g-scaling/sum
] unit-test

[ { 6 9 15 } ] [
    { 2 3 5 } 30 om-scale/sum
] unit-test

[ { { 2 2 } { 5 2 } } ] [
    100 factorize
] unit-test

[ 0 ] [
    99 [1,b] \ + -4950 reduce-tree
] unit-test

[ 720.0 ] [
    6 [1,b] \ * f reduce-tree
] unit-test

[ 720.0 ] [
    6 [1,b] [ * ] f reduce-tree
] unit-test

[ { 2.5 } ] [
    0 1 2 3 interpolation
] unit-test

[ { { 2.5 3.0 } } ] [
    0 1 2 { 3 4 } interpolation
] unit-test

[ { 1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0 } ] [
    0 10 1 10 interpolation
] unit-test

[ { { 1.0 2.0 3.0 }
    { 3.25 4.0 4.75 }
    { 5.5 6.0 6.5 }
    { 7.75 8.0 8.25 }
    { 10.0 10.0 10.0 } } ] [
    0 5 { 1 2 3 } 10 interpolation
] unit-test

[ { { 1.0 2.0 3.0 }
    { 2.0 3.0 4.0 }
    { 3.0 4.0 5.0 }
    { 4.0 5.0 6.0 } } ] [
    0 4 { 1 2 3 } { 4 5 6 } interpolation
] unit-test

[ { 3 5 } ] [
    { 0 1 2 3 4 3 2 } 3 f rang-p
] unit-test

[ { 0 1 2 6 } ] [
    { 0 1 2 3 4 3 2 } 3 [ < ] rang-p
] unit-test

[ { { 1 2 3 4 5 } { 6 7 8 9 } } ] [
    9 [1,b] 2 list-explode
] unit-test

[ { { 1 2 } { 3 4 } { 5 } { 6 7 } { 8 9 } } ] [
    9 [1,b] 5 list-explode
] unit-test

[ { { 1 } { 2 } { 3 } { 4 } { 5 } { 6 } { 7 } { 8 } { 9 } { 9 } { 9 } { 9 } } ] [
    9 [1,b] 12 list-explode
] unit-test

[ { 5 6 8 } ] [
    { 5 6 "a" "b" 8 } [ number? ] 'pass list-filter
] unit-test

[ { "a" "b" } ] [
    { 5 6 "a" "b" 8 } [ number? ] 'reject list-filter
] unit-test

[ { { 4 5 6 } } ] [
    { { 1 2 3 } { 4 5 6 } { 7 8 9 } } 1 \ odd? 'pass table-filter
] unit-test

[ { { 1 2 3 } { 7 8 9 } } ] [
    { { 1 2 3 } { 4 5 6 } { 7 8 9 } } 1 \ odd? 'reject table-filter
] unit-test

[ { 3 4 5 10 11 } ] [
    11 [1,b] >array { { 3 5 } { 10 11 } } 'pass band-filter
] unit-test

[ { 1 2 6 7 8 9 } ] [
    11 [1,b] >array { { 3 5 } { 10 11 } } 'reject band-filter
] unit-test

[ { 10 11 13 14 } ] [
    { 10 11 12 13 14 15 16 } { { 0 1 } { 3 4 } } 'pass range-filter
] unit-test

[ { 10 11 15 16 } ] [
    { 10 11 12 13 14 15 16 } { { 0 1 } { 5 6 } } 'pass range-filter
] unit-test

[ { 12 13 } ] [
    { 10 11 12 13 14 15 16 } { { 0 1 } { 4 6 } } 'reject range-filter
] unit-test

[ { 12 13 15 16 } ] [
    { 10 11 12 13 14 15 16 } { { 0 1 } { 4 4 } } 'reject range-filter
] unit-test

[ { { 10 20 } 50 { 70 } } ] [
    { 10 20 30 40 50 60 70 80 90 } { { 0 1 } 4 { 6 } } posn-match
] unit-test

[ { 10 10 10 40 50 60 70 } ] [
    { 10 20 30 40 50 60 70 80 90 } 3 0 <repetition> 3 6 [a,b] append posn-match
] unit-test
