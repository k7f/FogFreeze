! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.sequences arrays assocs circular fry kernel macros math
       math.combinatorics math.order om.support quotations random sequences
       sequences.deep sorting words ;
IN: om.combinatorial

! ____________________________________________
! 01-basicproject/functions/combinatorial.lisp

SYMBOL: :rec

<PRIVATE
GENERIC: (less>compare) ( fun -- quot: ( obj1 obj2 -- <=> ) )

M: word (less>compare) ( sym -- quot: ( obj1 obj2 -- <=> ) )
    1quotation (less>compare) ; inline

M: callable (less>compare) ( quot: ( obj1 obj2 -- ? ) -- quot: ( obj1 obj2 -- <=> ) )
    dup '[ 2dup @ [ 2drop +lt+ ] [ swap @ +gt+ +eq+ ? ] if ] ; inline

: (rec-map) ( ..a obj quot: ( ..a elt -- ..b elt' ) -- ..b newobj )
    '[ dup ,:branch? [ dup first ,:branch? [ @ ] unless ] when ] deep-map ; inline
PRIVATE>

: sort-list ( seq &keys -- seq' )
    [ [ < ] at-test&key (less>compare) ] [ :rec swap at ] bi
    [ [ sort ] curry (rec-map) ] [ sort ] if ; inline

GENERIC# rotate 1 ( seq &optionals -- seq' )

M: sequence rotate ( seq &optionals -- seq' )
    over [ unpack1 [ 1 ] unless* circular boa ] dip clone-like ;

GENERIC: nth-random ( seq -- seq' )

M: sequence nth-random ( seq -- seq' ) random ; inline

GENERIC: permut-random ( seq -- seq' )

M: sequence permut-random ( seq -- seq' ) clone randomize ;

<PRIVATE
: (sort-keys) ( seq quot: ( obj1 obj2 -- <=> ) -- seq' )
    [ [ first ] bi@ ] prepose sort ; inline
PRIVATE>

MACRO: posn-order ( fun -- quot: ( seq -- seq' ) )
    (less>compare) '[
        [ 2array ] map-index _ (sort-keys) values
    ] ;

GENERIC: permutations ( seq -- seq' )

M: sequence permutations ( seq -- seq' ) all-permutations ; inline
