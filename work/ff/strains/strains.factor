! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors arrays classes classes.parser classes.tuple classes.tuple.parser
       combinators debugger effects ff io kernel lexer make math namespaces
       parser prettyprint quotations sequences strings ;
IN: ff.strains

GENERIC: strain= ( strain1 strain2 -- ? )
GENERIC: check ( state new-value strain -- state new-value strain/f )

TUPLE: strain
    { failure# fixnum }
    { max-failures maybe-fixnum }
    { push-quotation maybe-callable }
    { drop-quotation maybe-callable } ;

: new-strain ( class -- strain )
    new 0 >>failure# f >>max-failures f >>push-quotation f >>drop-quotation ;

<PRIVATE
: (validate-strain-updates) ( push-quot drop-quot -- push-quot drop-quot )
     [ ( hitstack value strain -- ) validate-effect ]
     [ ( strain -- ) validate-effect ] bi* ;
PRIVATE>

: new-stateful-strain ( push-quot drop-quot class -- strain )
    [ (validate-strain-updates) ] dip
    new 0 >>failure# f >>max-failures
    swap >>drop-quotation swap >>push-quotation ;

M: strain strain= tuple= ; inline

: strain-check-failure ( state new-value strain -- state new-value strain/f )
    dup failure#>> 1 +
!    "failure " write dup pprint ". " write over class name>> .
    over max-failures>> [
        over < [ drop throw ] when
    ] when* >>failure# ; inline

M: strain check strain-check-failure ;

<PRIVATE
: (parse-strain-definition) ( -- class superclass slots )
    scan-new-class scan-token {
        { ";" [ strain f ] }
        { "<" [ scan-word [ parse-tuple-slots ] { } make ] }
        [
            strain swap
            [ parse-slot-name [ parse-tuple-slots ] when ] { }
            make
        ]
    } case dup check-duplicate-slots 3dup check-slot-shadowing ;
PRIVATE>

SYNTAX: STRAIN: (parse-strain-definition) define-tuple-class ;

TUPLE: in-vein < strain message ;
: <in-vein> ( message/f -- strain )
    \ in-vein new-strain 666 >>max-failures swap >>message ;
M: in-vein strain= 2drop f ; inline
M: in-vein error.
    message>> dup string? [ write ": " write ] [ drop ] if
    "all in vein..." print ;

<PRIVATE
ERROR: (invalid-input-strain) { error strain read-only } ;
M: (invalid-input-strain) error. "Invalid input: " write error>> error. ;
PRIVATE>

M: strain invalid-input (invalid-input-strain) ;

ERROR: bad-strain { error strain read-only } { message string read-only } ;

M: bad-strain error.
    "Bad strain (" over message>> "): " [ write ] tri@ error>> . ;

<PRIVATE
: (same-strain?) ( strain1 strain2 -- ? )
    2dup eq? [ 2drop t ] [
        over tuple? [ strain= ] [ 2drop f ] if
    ] if ; inline

: (lookup-strain) ( chain class -- ndx/f found/f )
    [ instance? ] curry find ; inline

: (change-strain) ( chain strain ndx -- chain' )
    rot [ set-nth ] keep clone ; inline

: (change-strain!) ( chain strain ndx -- chain )
    rot [ set-nth ] keep ; inline

: (remove-strain) ( chain ndx -- chain' )
    swap remove-nth ; inline

: (remove-strain!) ( chain ndx -- chain )
    swap remove-nth! ; inline

: (insert-strain) ( chain strain -- chain' )
    suffix ; inline

: (insert-strain!) ( chain strain -- chain )
    suffix! ; inline

: (set-strain) ( chain strain/f class -- chain' )
    [ over ] dip (lookup-strain) [
        pick (same-strain?) [ 2drop clone ] [
            swap [ swap (change-strain) ] [ (remove-strain) ] if*
        ] if
    ] [
        drop [ (insert-strain) ] [ clone ] if*
    ] if* ;

: (set-strain!) ( chain strain/f class -- chain )
    [ over ] dip (lookup-strain) [
        pick (same-strain?) [ 2drop ] [
            swap [ swap (change-strain!) ] [ (remove-strain!) ] if*
        ] if
    ] [
        drop [ (insert-strain!) ] when*
    ] if* ;
PRIVATE>

! ________________
! strain chain API

: build-chain ( guards ctors -- chain )
    [ f ] 2dip [ execute( chain guard/f -- chain' ) ] 2each ;

: chain-grow ( guards ctors chain -- chain' )
    -rot [ execute( chain guard/f -- chain' ) ] 2each ;

: chain-in ( strain chain -- chain' )
    swap [ dup class-of (set-strain) ] [ f "chain-in error" bad-strain ] if* ;

: chain-out ( class chain -- chain' )
    swap f swap (set-strain) ;

: chain-reset ( chain -- chain' ) drop f ;
: chain-reset! ( chain -- chain ) [ delete-all ] keep ;

: chain-failures ( chain -- report )
    [ [ class-of ] keep failure#>> 2array ] map ;

! ________________
! with-strains API

ALIAS: build-strains build-chain

SYMBOL: all-strains

: with-strains ( strains quot -- )
    [ all-strains ] dip with-variable ; inline

: strains-failures ( -- report ) all-strains get chain-failures ;
: strains. ( -- ) all-strains get . ;
