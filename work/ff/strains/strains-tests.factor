! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors classes continuations ff.strains ff.strains.generic ff.strains.simple
       kernel math namespaces prettyprint sequences tools.test ;
IN: ff.strains.tests

SYMBOL: strain-chain

: reset-strains ( -- ) strain-chain [ get reset-chain ] [ set ] bi ;

: put-max-depth ( guard count -- ) [ strain-chain get ] 2dip set-overdepth strain-chain set ;
: put-max-value ( guard value -- ) [ strain-chain get ] 2dip set-overflow strain-chain set ;
: put-all-different ( guard -- ) [ strain-chain get ] dip set-all-different strain-chain set ;

[ T{ in-vein f 0 666 f f "test" } ] [
    "test" <in-vein>
] unit-test

[ { T{ overdepth f 0 0 f f 0 4 } } ] [
    reset-strains 0 5 put-max-depth strain-chain get
] unit-test

[ { T{ overflow f 0 0 f f 0 15 } } ] [
    reset-strains 0 15 put-max-value strain-chain get
] unit-test

[ { T{ overdepth f 0 0 f f 0 4 } T{ overflow f 0 0 f f 0 15 } } ] [
    reset-strains 0 5 put-max-depth 0 15 put-max-value strain-chain get
] unit-test

[ { T{ all-different f 0 0 f f } } ] [
    reset-strains 0 put-all-different strain-chain get
] unit-test

ALL-DIFFERENT2: all-different-delta - ;

: put-all-different-delta ( guard -- )
    [ strain-chain get ] dip set-all-different-delta strain-chain set ;

[ { all-different-delta } ] [
    reset-strains 0 put-all-different-delta
    strain-chain get dup first [ push-quotation>> ] [ drop-quotation>> ] bi . .
    [ class-of ] map
] unit-test

[ f ] [
    reset-strains strain-chain get
] unit-test

ALL-DIFFERENT2: all-different-delta12rem - 12 rem ;

: put-all-different-delta12rem ( guard -- )
    [ strain-chain get ] dip set-all-different-delta12rem strain-chain set ;

[ { all-different-delta12rem } ] [
    reset-strains 0 put-all-different-delta12rem
    strain-chain get dup first [ push-quotation>> ] [ drop-quotation>> ] bi . .
    [ class-of ] map
] unit-test

STRAIN: test-strain ;

[ T{ bad-strain f T{ test-strain f 0 1 f f } "nevermind" } ] [
    \ test-strain new-strain 1 >>max-failures
    [ "nevermind" bad-strain ] [ ] recover nip
] unit-test
