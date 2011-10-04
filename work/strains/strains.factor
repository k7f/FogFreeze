! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors classes classes.tuple debugger io kernel math
       namespaces sequences strings ;
IN: strains

MIXIN: maybe-fixnum
INSTANCE: f maybe-fixnum
INSTANCE: fixnum maybe-fixnum

GENERIC: strain= ( strain1 strain2 -- ? )
GENERIC: check ( state new-value strain -- state new-value strain/f )

TUPLE: strain { failure# fixnum } { max-failures maybe-fixnum } ;
: new-strain ( class -- strain )
    new 0 >>failure# f >>max-failures ;
M: strain strain= tuple= ; inline
M: strain check
    dup failure#>> 1 +
    over max-failures>> [
        over < [ drop throw ] when
    ] when* >>failure# ; inline

TUPLE: in-vein < strain message ;
: <in-vein> ( message/f -- strain )
    \ in-vein new-strain 666 >>max-failures swap >>message ;
M: in-vein strain= 2drop f ; inline
M: in-vein error.
    message>> dup string? [ write ": " write ] [ drop ] if
    "all in vein..." print ;

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
