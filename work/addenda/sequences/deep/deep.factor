! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: fry kernel quotations sequences sequences.deep strings ;
IN: addenda.sequences.deep

! FIXME find out why is quotation a basis:branch?
GENERIC: ,:branch? ( obj -- ? )

M: quotation ,:branch? drop f ;
M: string    ,:branch? drop f ;
M: sequence  ,:branch? drop t ;
M: object    ,:branch? drop f ;

: deep-map-atoms ( ..a obj quot: ( ..a elt -- ..b elt' ) -- ..b newobj )
    '[ dup ,:branch? [ @ ] unless ] deep-map ; inline

! FIXME keep the structure
: deep-filter-atoms ( ..a obj quot: ( ..a elt -- ..b ? ) -- ..b seq )
    over [
        selector [ '[ dup ,:branch? [ drop ] [ @ ] if ] deep-each ] dip
    ] dip dup ,:branch? [ like ] [ drop ] if ; inline

: deep-reduce ( ..a obj identity quot: ( ..a prev elt -- ..b next ) -- ..b result )
    swapd '[ dup ,:branch? [ drop ] [ @ ] if ] deep-each ; inline
