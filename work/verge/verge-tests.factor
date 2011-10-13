! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors arrays continuations kernel math namespaces sequences
       strains strains.generic strains.simple tools.test verge verge.private ;
IN: verge.tests

SYMBOL: strain-chain

: reset-strains ( -- ) strain-chain reset-chain ;

: set-max-depth ( guard depth -- ) [ strain-chain ] 2dip set-overdepth ;
: set-max-value ( guard value -- ) [ strain-chain ] 2dip set-overflow ;
: set-min-value ( guard value -- ) [ strain-chain ] 2dip set-underflow ;

: slip-once+1 ( value -- value slip )
    dup [
        1 + f
    ] curry ;

: slip-twice+1 ( value -- value slip )
    dup [
        1 + slip-once+1
    ] curry ;

: slip-ntimes+1 ( value slip# -- value slip )
    over [
        1 + swap 1 - dup 0 > [ slip-ntimes+1 ] [ drop f ] if
    ] 2curry ;

: hotpo ( start first-slip-maker next-slip-maker -- hitlist ? )
    [ 1array ] 2dip
    strain-chain get clone
    [ 1 <= ]
    [ dup odd? [ 3 * 1 + ] [ 2 /i ] if ]
    verge ; inline

2 set-trace

[ V{ 13 40 20 10 5 16 8 4 2 1 } t ]
[ reset-strains 13 [ f ] dup hotpo ] unit-test

[ V{ 13 40 20 10 5 } f ]
[ 0 5 set-max-depth 13 [ f ] dup hotpo reset-strains ] unit-test

[ V{ 13 } f ]
[ 0 5 set-max-depth 0 15 set-max-value 13 [ f ] dup hotpo reset-strains ] unit-test

[ V{ 13 40 20 11 34 17 52 26 13 40 20 11 34 17 52 26 13 40 20 } f ]
[ 2 11 set-min-value 13 [ f ] [ slip-once+1 ] hotpo reset-strains ] unit-test

[ V{ 13 40 21 64 32 16 } f ]
[ 2 12 set-min-value 13 [ f ] [ slip-once+1 ] hotpo reset-strains ] unit-test

[ V{ 13 40 21 65 197 } f ]
[ 7 5 set-max-depth 2 12 set-min-value 13 [ f ] [ slip-once+1 ] hotpo reset-strains ] unit-test

: (vary-set-strains) ( ctor -- )
    [ strain-chain 18 ] dip execute ; inline

: (vary-slip-makers) ( slip# -- first-slip-maker next-slip-maker )
    [ f ] swap [ slip-ntimes+1 ] curry ; inline

: vary ( start slip# ctor -- hitlist ? )
    (vary-set-strains) (vary-slip-makers) 
    strain-chain get clone
    [ drop dup length [ 7 = ] [ 2 = ] bi or ]
    [ ]
    verge ; inline

[ V{ 13 14 15 16 17 18 19 } t ]
[ { 13 14 15 } 2 \ set-all-different vary reset-strains ] unit-test

[ V{ 13 14 } t ]
[ 7 3 set-max-depth { 13 14 } 2 \ set-all-different vary reset-strains ] unit-test

[ V{ 13 14 15 } f ]
[ 7 3 set-max-depth { 13 14 15 } 2 \ set-all-different vary reset-strains ] unit-test

[ V{ 13 14 16 19 23 28 34 } t ]
[ { 13 14 16 } 6 \ set-all-different-delta vary reset-strains ] unit-test

[ { 13 14 15 } set-all-different-delta ]
[ { 13 14 15 } 6 \ set-all-different-delta [ vary ] [ drop nip ] recover reset-strains ] unit-test
