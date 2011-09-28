! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: kernel math namespaces strains strains.simple tools.test ;
IN: strains.tests

SYMBOL: strain-chain

: reset-strains ( -- )
    strain-chain reset-chain ;

: set-max-loops ( count/f -- )
    dup [ <overloop> ] when overloop
    [ strain-chain ] 2dip set-strain ;

: set-max-value ( value/f -- )
    dup [ <overflow> ] when overflow
    [ strain-chain ] 2dip set-strain ;

[ { T{ overloop f 0 0 0 4 } } ]
[ reset-strains 5 set-max-loops strain-chain get ] unit-test

[ { T{ overflow f 0 0 0 15 } } ]
[ reset-strains 15 set-max-value strain-chain get ] unit-test

[ { T{ overloop f 0 0 0 4 } T{ overflow f 0 0 0 15 } } ]
[ reset-strains 5 set-max-loops 15 set-max-value strain-chain get ] unit-test

[ f ]
[ reset-strains strain-chain get ] unit-test
