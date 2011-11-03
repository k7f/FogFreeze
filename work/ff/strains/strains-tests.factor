! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors classes continuations ff ff.strains ff.strains.generic
       ff.strains.simple kernel math namespaces prettyprint sequences tools.test ;
IN: ff.strains.tests

set-tracing-off

[ T{ in-vein f 0 666 f f "test" } ] [
    "test" <in-vein>
] unit-test

[ T{ overdepth f 0 0 f f 0 4 } ] [
    0 5 <overdepth>
] unit-test

[ { T{ overflow f 0 0 f f 0 15 } } ] [
    0 15 <overflow> f chain-in
] unit-test

[ { T{ overdepth f 0 0 f f 0 4 } T{ overflow f 0 0 f f 0 15 } } ] [
    f 0 5 <overdepth> 0 15 <overflow> [ swap chain-in ] bi@
] unit-test

: +15overflow+ ( chain guard/f -- chain' ) 15 <overflow> swap chain-in ;
: +5overdepth+ ( chain guard/f -- chain' ) 5 <overdepth> swap chain-in ;

[ { T{ overdepth f 0 0 f f 0 4 } T{ overflow f 0 0 f f 0 15 } } ] [
    { 0 0 } { +5overdepth+ +15overflow+ } build-strains
] unit-test

[ { T{ all-different f 0 0 f f } } ] [
    0 <all-different> f chain-in
] unit-test

[ { T{ all-different f 0 0 f f } } ] [
    { 0 } { +all-different+ } build-strains
] unit-test

ALL-DIFFERENT2: all-different-delta - ;

[ { all-different-delta } ] [
    0 <all-different-delta> f chain-in
    dup first [ push-quotation>> ] [ drop-quotation>> ] bi . .
    [ class-of ] map
] unit-test

[ { all-different-delta } ] [
    { 0 } { +all-different-delta+ } build-strains
    [ class-of ] map
] unit-test

ALL-DIFFERENT2: all-different-delta12rem - 12 rem ;

[ { all-different-delta12rem } ] [
    0 <all-different-delta12rem> f chain-in
    dup first [ push-quotation>> ] [ drop-quotation>> ] bi . .
    [ class-of ] map
] unit-test

[ { all-different-delta12rem } ] [
    { 0 } { +all-different-delta12rem+ } build-strains
    [ class-of ] map
] unit-test

STRAIN: test-strain ;

[ T{ bad-strain f T{ test-strain f 0 1 f f } "nevermind" } ] [
    \ test-strain new-strain 1 >>max-failures
    [ "nevermind" bad-strain ] [ ] recover nip
] unit-test

[ f ] [
    f [ all-strains get ] with-strains
] unit-test

[ { all-different-delta12rem } ] [
    { 0 } { +all-different-delta12rem+ } build-strains [
        all-strains get
    ] with-strains [ class-of ] map
] unit-test

[ V{ 5 6 7 11 } ] [
    { 1 2 3 } 14 0 <all-different-delta> dup bistack>> V{ 5 6 7 } append!
    [ dup push-quotation>> call( hitstack value strain -- ) ] dip
] unit-test

[ V{ 5 6 } ] [
    0 <all-different-delta> dup bistack>> V{ 5 6 7 } append!
    [ dup drop-quotation>> call( strain -- ) ] dip
] unit-test
