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
     [ (( hitstack value strain -- )) validate-effect ]
     [ (( strain -- )) validate-effect ] bi* ;
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
    CREATE-CLASS scan {
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

: (lookup-strain) ( chain strain/f class -- chain strain/f ndx/f found/f )
    [ instance? ] curry [ over get ] dip find ; inline

: (change-strain) ( chain strain ndx -- )
    rot get set-nth ; inline

: (remove-strain) ( chain ndx -- )
    swap [ get remove-nth ] keep set ; inline

: (insert-strain) ( chain strain -- )
    swap [ get swap suffix ] keep set ; inline
PRIVATE>

: set-strain ( chain strain/f class -- )
    (lookup-strain) [
        pick (same-strain?) [ 3drop ] [
            swap [ swap (change-strain) ] [ (remove-strain) ] if*
        ] if
    ] [
        drop [ (insert-strain) ] [ drop ] if*
    ] if* ;

: reset-chain ( chain -- )
    f swap set ;

: fail-counts ( chain -- report )
    get [ [ class ] keep failure#>> 2array ] map ;
