! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: kernel math namespaces strains strains.generic strains.simple tools.test ;
IN: strains.tests

SYMBOL: strain-chain

: reset-strains ( -- ) strain-chain reset-chain ;

: set-max-loops ( guard count -- ) [ strain-chain ] 2dip set-overloop ;
: set-max-value ( guard value -- ) [ strain-chain ] 2dip set-overflow ;

[ { T{ overloop f 0 0 0 4 } } ]
[ reset-strains 0 5 set-max-loops strain-chain get ] unit-test

[ { T{ overflow f 0 0 0 15 } } ]
[ reset-strains 0 15 set-max-value strain-chain get ] unit-test

[ { T{ overloop f 0 0 0 4 } T{ overflow f 0 0 0 15 } } ]
[ reset-strains 0 5 set-max-loops 0 15 set-max-value strain-chain get ] unit-test

[ f ]
[ reset-strains strain-chain get ] unit-test
