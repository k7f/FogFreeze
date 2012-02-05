! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: arrays fry kernel macros om.support quotations sequences sets words ;
IN: om.sets

! ___________________________________
! 01-basicproject/functions/sets.lisp

<PRIVATE
MACRO: (x-set-operator) ( &keys word* word -- quot: ( seq1 seq2 &rest -- seq' ) )
    [ &keys:test:key>quotation* ] 2dip pick [ = ] =
    [ 2nip 1quotation dup dup ]
    [ drop 1quotation curry dup dup ] if
    '[ &rest>sequence [ _ dip swap _ reduce ] _ if* ] ;
PRIVATE>

: x-union ( seq1 seq2 &keys &rest -- seq' )
    swap \ union* \ union (x-set-operator) ; inline

: x-intersect ( seq1 seq2 &keys &rest -- seq' )
    swap \ intersect* \ intersect (x-set-operator) ; inline

: x-diff ( seq1 seq2 &keys &rest -- seq' )
    swap \ diff* \ diff (x-set-operator) ; inline

: x-xor ( seq1 seq2 &keys &rest -- seq' )
    swap \ symmetric-diff* \ symmetric-diff (x-set-operator) ; inline

: included? ( seq1 seq2 f/quot: ( obj1 obj2 -- ? ) -- ? )
    [ subset*? ] [ subset? ] if* ; inline
