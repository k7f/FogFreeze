! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors assocs classes classes.tuple kernel sequences ;
IN: addenda.classes.tuple

ERROR: not-a-subclass base-obj obj base-class class ;

GENERIC: clone-as ( obj exemplar -- newobj )

M: tuple clone-as ( obj exemplar -- newobj )
    [ dup class-of ] bi@ rot 2dup subclass-of? [
        drop [
            [ tuple-slots ] bi@
            [ 0 swap copy ] keep
        ] dip slots>tuple
    ] [ swap not-a-subclass ] if ;

: clone-as* ( obj newslots newclass -- newobj )
    pick class-of 2dup subclass-of? [
        drop [ tuple-slots ] [ append ] [ slots>tuple ] tri*
    ] [ [ drop f ] 2dip swap not-a-subclass ] if ;

: tuple>assoc ( tuple -- assoc )
    [ class-of all-slots [ name>> ] map ]
    [ tuple-slots ] bi zip ;

: supply-defaults ( tuple defaults -- tuple' )
    over tuple>assoc [
        dup second [ 2nip ] [
            first swap at [ f ] unless*
        ] if*
    ] with map swap class-of slots>tuple ;
