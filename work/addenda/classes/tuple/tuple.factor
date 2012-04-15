! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors assocs classes classes.tuple kernel sequences ;
IN: addenda.classes.tuple

: tuple>assoc ( tuple -- assoc )
    [ class-of all-slots [ name>> ] map ]
    [ tuple-slots ] bi zip ;

: supply-defaults ( tuple defaults -- tuple' )
    over tuple>assoc [
        dup second [ 2nip ] [
            first swap at [ f ] unless*
        ] if*
    ] with map swap class-of slots>tuple ;

: new-derived ( obj newslots newclass -- newobj )
    [ tuple-slots ] [ append ] [ slots>tuple ] tri* ;
