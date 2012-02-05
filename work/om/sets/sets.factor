! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: arrays fry kernel macros om.support quotations sequences sets words ;
IN: om.sets

! ___________________________________
! 01-basicproject/functions/sets.lisp

<PRIVATE
MACRO: (x-set-operator) ( word* word -- quot: ( seq1 seq2 &keys &rest -- seq' ) )
    drop ! FIXME
    1quotation dup dup '[
        [ &keys:test:key>quotation* ] [ &rest>sequence ] bi*
        [ [ _ keep ] dip -rot _ curry reduce ] _ if*
    ] ;
PRIVATE>

: x-union ( seq1 seq2 &keys &rest -- seq' )
    \ union* \ union (x-set-operator) ; inline

: x-intersect ( seq1 seq2 &keys &rest -- seq' )
    \ intersect* \ intersect (x-set-operator) ; inline

: x-diff ( seq1 seq2 &keys &rest -- seq' )
    \ diff* \ diff (x-set-operator) ; inline

: x-xor ( seq1 seq2 &keys &rest -- seq' )
    \ symmetric-diff* \ symmetric-diff (x-set-operator) ; inline

: included? ( seq1 seq2 f/quot: ( obj1 obj2 -- ? ) -- ? )
    [ subset*? ] [ subset? ] if* ; inline
