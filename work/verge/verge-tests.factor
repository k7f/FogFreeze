! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors kernel math namespaces strains strains.simple tools.test verge ;
IN: verge.tests

SYMBOL: strain-chain

: reset-strains ( -- )
    strain-chain reset-chain ;

: set-max-loops ( count/f -- )
    dup [ <overloop> ] when overloop
    [ strain-chain ] 2dip set-strain ;

: set-max-value ( value/f -- )
    dup [ <overflow> ] when overflow
    [ strain-chain ] 2dip set-strain ;

: set-min-value ( value/f -- )
    strain-chain swap
    dup [ <underflow> 2 >>max-failures ] when
    underflow set-strain ;

: make-slip ( value -- value slip )
    dup [
        1 + f
    ] curry ;

: hotpo ( start first-slip-maker next-slip-maker -- seq ? )
    strain-chain get clone
    [ 1 <= ]
    [ dup odd? [ 3 * 1 + ] [ 2 /i ] if ]
    verge ; inline

[ V{ 13 40 20 10 5 16 8 4 2 1 } t ]
[ reset-strains 13 [ f ] dup hotpo ] unit-test

[ V{ 13 40 20 10 5 } f ]
[ 5 set-max-loops 13 [ f ] dup hotpo reset-strains ] unit-test

[ V{ 13 40 20 11 34 17 52 26 13 40 20 11 34 17 52 26 13 40 20 } f ]
[ 11 set-min-value 13 [ f ] [ make-slip ] hotpo reset-strains ] unit-test

[ V{ 13 } f ]
[ 5 set-max-loops 15 set-max-value 13 [ f ] dup hotpo reset-strains ] unit-test
