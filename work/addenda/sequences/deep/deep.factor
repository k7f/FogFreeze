! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.sequences fry kernel sequences sequences.deep ;
IN: addenda.sequences.deep

: deep-map-atoms ( ..a obj quot: ( ..a elt -- ..b elt' ) -- ..b newobj )
    '[ dup atom? [ @ ] when ] deep-map ; inline

! FIXME keep the structure
: deep-filter-atoms ( ..a obj quot: ( ..a elt -- ..b ? ) -- ..b seq )
    over [
        selector [ '[ dup atom? [ @ ] [ drop ] if ] deep-each ] dip
    ] dip dup atom? [ drop ] [ like ] if ; inline

: deep-reduce ( ..a obj identity quot: ( ..a prev elt -- ..b next ) -- ..b result )
    swapd '[ dup atom? [ @ ] [ drop ] if ] deep-each ; inline
