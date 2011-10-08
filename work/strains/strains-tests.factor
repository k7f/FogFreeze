! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors classes kernel math namespaces prettyprint sequences strains
       strains.generic strains.simple tools.test ;
IN: strains.tests

SYMBOL: strain-chain

: reset-strains ( -- ) strain-chain reset-chain ;

: set-max-depth ( guard count -- ) [ strain-chain ] 2dip set-overdepth ;
: set-max-value ( guard value -- ) [ strain-chain ] 2dip set-overflow ;

[ T{ in-vein f 0 666 f f "test" } ]
[ "test" <in-vein> ] unit-test

[ { T{ overdepth f 0 0 f f 0 4 } } ]
[ reset-strains 0 5 set-max-depth strain-chain get ] unit-test

[ { T{ overflow f 0 0 f f 0 15 } } ]
[ reset-strains 0 15 set-max-value strain-chain get ] unit-test

[ { T{ overdepth f 0 0 f f 0 4 } T{ overflow f 0 0 f f 0 15 } } ]
[ reset-strains 0 5 set-max-depth 0 15 set-max-value strain-chain get ] unit-test

[ { T{ all-different f 0 0 f f } } ]
[ reset-strains strain-chain 0 set-all-different strain-chain get ] unit-test

[ { all-different-delta } ]
[ reset-strains strain-chain 0 set-all-different-delta
  strain-chain get dup first [ push-quotation>> ] [ pop-quotation>> ] bi . .
  [ class ] map ] unit-test

[ f ]
[ reset-strains strain-chain get ] unit-test
