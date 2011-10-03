! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors kernel math namespaces sequences strains strains.generic
       strains.simple tools.test verge ;
IN: verge.tests

SYMBOL: strain-chain

: reset-strains ( -- ) strain-chain reset-chain ;

: set-max-loops ( guard count -- ) [ strain-chain ] 2dip set-overloop ;
: set-max-value ( guard value -- ) [ strain-chain ] 2dip set-overflow ;
: set-min-value ( guard value -- ) [ strain-chain ] 2dip set-underflow ;

: make-slip ( value -- value slip )
    dup [
        1 + f
    ] curry ;

: hotpo ( start first-slip-maker next-slip-maker -- hitlist ? )
    strain-chain get clone
    [ 1 <= ]
    [ dup odd? [ 3 * 1 + ] [ 2 /i ] if ]
    verge ; inline

2 set-trace

[ V{ 13 40 20 10 5 16 8 4 2 1 } t ]
[ reset-strains 13 [ f ] dup hotpo ] unit-test

[ V{ 13 40 20 10 5 } f ]
[ 0 5 set-max-loops 13 [ f ] dup hotpo reset-strains ] unit-test

[ V{ 13 } f ]
[ 0 5 set-max-loops 0 15 set-max-value 13 [ f ] dup hotpo reset-strains ] unit-test

[ V{ 13 40 20 11 34 17 52 26 13 40 20 11 34 17 52 26 13 40 20 } f ]
[ 2 11 set-min-value 13 [ f ] [ make-slip ] hotpo reset-strains ] unit-test

[ V{ 13 40 21 64 32 16 } f ]
[ 2 12 set-min-value 13 [ f ] [ make-slip ] hotpo reset-strains ] unit-test

[ V{ 13 40 21 65 197 } f ]
[ 7 5 set-max-loops 2 12 set-min-value 13 [ f ] [ make-slip ] hotpo reset-strains ] unit-test

: vary ( start -- hitlist ? )
    strain-chain 3 set-all-different
    [ f ] [ make-slip ] strain-chain get clone
    [ drop dup length 7 = ]
    [ 1 + ]
    verge ; inline

[ V{ 13 14 15 16 17 18 19 } t ]
[ 13 vary reset-strains ] unit-test
