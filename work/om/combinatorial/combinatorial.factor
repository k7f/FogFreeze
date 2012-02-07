! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.sequences.deep arrays assocs fry kernel math math.order
       om.support prettyprint sequences sequences.deep sorting ;
IN: om.combinatorial

! ____________________________________________
! 01-basicproject/functions/combinatorial.lisp

SYMBOL: :rec

<PRIVATE
: (less>compare) ( quot: ( obj1 obj2 -- ? ) -- quot': ( obj1 obj2 -- <=> ) )
    dup '[ 2dup @ [ 2drop +lt+ ] [ swap @ +gt+ +eq+ ? ] if ] ; inline

: (rec-map) ( ..a obj quot: ( ..a elt -- ..b elt' ) -- ..b newobj )
    '[ dup ,:branch? [ dup first ,:branch? [ @ ] unless ] when ] deep-map ; inline
PRIVATE>

: sort-list ( seq &keys -- seq' )
    [ [ < ] at-test&key (less>compare) ] [ :rec swap at ] bi
    [ [ sort ] curry (rec-map) ] [ sort ] if ; inline
