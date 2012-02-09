! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: bit-sets bit-sets.private kernel math sequences sets sets.private
       vectors ;
IN: addenda.sets

! FIXME handle all sets by slow-set coercion (except special-cased bit-sets)

<PRIVATE
: (?add-member*) ( elt vec quot: ( obj1 obj2 -- ? ) -- )
    [ over ] dip curry dupd any?
    [ 2drop ] [ push ] if ; inline

: (members*) ( seq quot: ( obj1 obj2 -- ? ) -- vec )
    [ dup length <vector> ] dip
    over [ [ (?add-member*) ] 2curry each ] dip ; inline
PRIVATE>

: members* ( seq quot: ( obj1 obj2 -- ? ) -- seq' )
    [ (members*) ] curry keep like ; inline

: set-like* ( seq quot: ( obj1 obj2 -- ? ) exemplar -- seq' )
    [ members* ] dip like ; inline

: union* ( seq1 seq2 quot: ( obj1 obj2 -- ? ) -- seq' )
    swap over 2dup swap [ [ members* ] 2bi@ append ] 2dip set-like* ; inline

<PRIVATE
: (sequence/tester*) ( seq1 seq2 quot: ( obj1 obj2 -- ? ) -- seq' quot: ( elt -- ? ) )
    dup [ members* ] curry 2dip [ with any? ] 2curry ; inline
PRIVATE>

: intersect* ( seq1 seq2 quot: ( obj1 obj2 -- ? ) -- seq' )
    dup pick [
        [ 2dup [ cardinality ] bi@ > [ swap ] when ] dip
        (sequence/tester*) filter
    ] 2dip set-like* ; inline

: diff* ( seq1 seq2 quot: ( obj1 obj2 -- ? ) -- seq' )
    dup pick [
        (sequence/tester*) [ not ] compose filter
    ] 2dip set-like* ; inline

GENERIC: symmetric-diff ( set1 set2 -- set' )

M: bit-set symmetric-diff ( set1 set2 -- set' )
    [ bitxor ] bit-set-op ;

M: set symmetric-diff ( set1 set2 -- set' )
    [
        2dup swap [ sequence/tester [ not ] compose filter ] 2bi@ append
    ] keep set-like ;

: symmetric-diff* ( seq1 seq2 quot: ( obj1 obj2 -- ? ) -- seq' )
    dup pick [
        3dup swapd [ (sequence/tester*) [ not ] compose filter ]
        [ 3dip ] keep call append
    ] 2dip set-like* ; inline

: subset*? ( seq1 seq2 quot: ( obj1 obj2 -- ? ) -- ? )
    pick pick [ cardinality ] bi@ >
    [ 3drop f ] [ (sequence/tester*) all? ] if ; inline
