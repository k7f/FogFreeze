! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: ff.benchmark kernel math.parser sequences tools.test ;
IN: ff.benchmark.tests

: (numbers>string-growing) ( seq -- string )
    [ number>string ] [ ", " glue ] map-reduce ;

: (numbers>string-preallocated) ( seq -- string )
    [ number>string ] map ", " join ;

: (numbers>string-candidates) ( -- quot1 quot2 )
    [ (numbers>string-growing) drop ]
    [ (numbers>string-preallocated) drop ] ; inline

[ { t t t t t t t } ] [
    (numbers>string-candidates) 3 0 6 .8 .25 power-compare-unary!
] unit-test
