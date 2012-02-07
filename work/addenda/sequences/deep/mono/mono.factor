! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.sequences fry kernel sequences sequences.deep ;
IN: addenda.sequences.deep.mono

! FIXME replace ad-hoc definitions of monomorphic combinators with generic macros

: fixed-deep-each ( obj quot: ( elt -- ) -- )
    [ call( elt -- ) ] 2keep over ,:branch?
    [ [ fixed-deep-each ] curry each ] [ 2drop ] if ; inline recursive

: fixed-deep-filter ( obj quot: ( elt -- ? ) -- seq )
    over [ selector [ fixed-deep-each ] dip ] dip dup ,:branch?
    [ like ] [ drop ] if ; inline

! FIXME keep the structure
: fixed-deep-filter-atoms ( obj quot: ( elt -- ? ) -- seq )
    over [
        selector [
            '[ dup ,:branch? [ drop ] [ _ call( elt -- ) ] if ] deep-each
        ] dip
    ] dip dup ,:branch? [ like ] [ drop ] if ; inline

: fixed-deep-reduce ( obj identity quot: ( prev elt -- next ) -- result )
    swapd '[ dup ,:branch? [ drop ] [ _ call( prev elt -- next ) ] if ] deep-each ; inline
