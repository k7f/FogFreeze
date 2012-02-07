! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.sequences.deep arrays assocs classes combinators ff.errors
       kernel locals macros math math.functions quotations sequences
       sequences.private strings words ;
IN: om.support

! __________
! &optionals

GENERIC: unpack1 ( &optionals -- arg1/f )

M: quotation unpack1 ( &optionals -- arg1/f ) ; inline
M: string    unpack1 ( &optionals -- arg1/f ) ; inline
M: sequence  unpack1 ( &optionals -- arg1/f ) [ f ] [ first ] if-empty ; inline
M: object    unpack1 ( &optionals -- arg1/f ) ; inline

MACRO: unpack1* ( &optionals -- quot: ( -- arg1/f ) )
    unpack1 1quotation ;

GENERIC# unpack2 1 ( &optionals arg1-default -- arg1 arg2/f )

M: quotation unpack2 ( &optionals arg1-default -- arg1 arg2/f ) drop f ; inline
M: string    unpack2 ( &optionals arg1-default -- arg1 arg2/f ) drop f ; inline

M: sequence unpack2 ( &optionals arg1-default -- arg1 arg2/f )
    swap [ f ] [
        nip dup length 1 = [ first f ] [ first2 ] if
    ] if-empty ;

M: object unpack2 ( &optionals arg1-default -- arg1 arg2/f ) drop f ; inline

MACRO: unpack2* ( &optionals arg1-default -- quot: ( -- arg1 arg2/f ) )
    unpack2 2array >quotation ;

GENERIC# unpack3 2 ( &optionals arg1-default arg2-default -- arg1 arg2 arg3/f )

M: quotation unpack3 ( &optionals arg1-default arg2-default -- arg1 arg2 arg3/f ) nip f ; inline
M: string    unpack3 ( &optionals arg1-default arg2-default -- arg1 arg2 arg3/f ) nip f ; inline

M: sequence unpack3 ( &optionals arg1-default arg2-default -- arg1 arg2 arg3/f )
    rot [ f ] [
        dup length {
            { 1 [ rot drop first swap f ] }
            { 2 [ 2nip first2 f ] }
            [ drop 2nip first3 ]
        } case
    ] if-empty ;

M: object unpack3 ( &optionals arg1-default arg2-default -- arg1 arg2 arg3/f ) nip f ; inline

MACRO: unpack3* ( &optionals arg1-default arg2-default -- quot: ( -- arg1 arg2 arg3/f ) )
    unpack3 3array >quotation ;

<PRIVATE
: (>callable) ( word/callable -- callable )
    dup word? [ 1quotation ] when ; inline

: (test&key>test) ( test: ( obj1 obj2 -- ? ) key: ( obj -- obj' ) -- quot: ( obj1 obj2 -- ? ) )
    [ [ (>callable) ] bi@ [ bi@ ] curry prepose ] [ (>callable) ] if* ; inline
PRIVATE>

MACRO: unpack-test&key ( &optionals test-default: ( obj1 obj2 -- ? ) -- quot: ( -- quot: ( obj1 obj2 -- ? ) ) )
    unpack2 (test&key>test) 1quotation ;

! _____
! &keys

SYMBOLS: :test :key ;

<PRIVATE
: (&keys>test&key) ( &keys test-default: ( obj1 obj2 -- ? ) -- test: ( obj1 obj2 -- ? ) key: ( obj -- obj' ) )
    swap :test :key rot [ at ] curry bi@ [ dup rot ? ] dip ; inline
PRIVATE>

MACRO: at-test&key ( &keys test-default: ( obj1 obj2 -- ? ) -- quot: ( -- quot: ( obj1 obj2 -- ? ) ) )
    (&keys>test&key) (test&key>test) 1quotation ;

! _____
! &rest

GENERIC: &rest>sequence ( &rest -- seq/f )

M: quotation &rest>sequence ( str -- seq/f ) 1array ; inline
M: string    &rest>sequence ( str -- seq/f ) 1array ; inline
M: sequence  &rest>sequence ( seq -- seq/f ) [ f ] when-empty ; inline
M: object    &rest>sequence ( obj -- seq/f ) 1array ; inline

! ________________
! binop generators

MACRO:: om-binop-number ( quot: ( elt1 elt2 -- elt' ) -- )
    [
        {
            { [ over number? ] quot }
            { [ over sequence? ] [ quot curry map ] }
            [ drop class-of invalid-input ]
        } cond
    ] ;

MACRO:: om-binop-sequence ( quot: ( elt1 elt2 -- elt' ) -- )
    [
        {
            { [ over number? ] [ quot with map ] }
            { [ over sequence? ] [ quot 2map ] }
            [ drop class-of invalid-input ]
        } cond
    ] ;

! accumulator

<PRIVATE
: (iterator) ( seq quot -- n quot' )
    [ [ length ] keep ] dip
    [ [ nth-unsafe ] dip curry keep ] 2curry ; inline

: (map-integers+) ( ..a len quot: ( ..a i -- ..b elt ) exemplar -- ..b newseq )
    [ over 1 + ] dip [ [ collect ] keep ] new-like ; inline
PRIVATE>

: accumulate-all-as ( ..a seq identity quot: ( ..a prev elt -- ..b next ) exemplar -- ..b newseq )
    [ swapd (iterator) ] dip pick
    [ (map-integers+) ] dip swap
    [ set-nth-unsafe ] keep ; inline

: accumulate-all ( ..a seq identity quot: ( ..a prev elt -- ..b next ) -- ..b newseq )
    pick accumulate-all-as ; inline

! ________________________
! a variant of sum-lengths

: sum-lengths-with-atoms ( seq -- n )
    0 [ dup ,:branch? [ length ] [ drop 1 ] if + ] reduce ; inline

! ____
! math

: >power-of-2 ( m -- n )
    dup 0 > [ log2 2^ ] [ drop 0 ] if ; inline

: cl-floor ( num div -- quo rem )
    2dup / floor [ * - ] [ >integer ] bi swap ;

: cl-identity ( obj -- obj ) ;

! _________
! find-tail

: find-tail ( seq candidates -- tailseq/f )
    dupd [
        [ eq? ] with find drop
    ] curry find drop [ tail ] [ drop f ] if* ; inline

: find-tail* ( seq candidates -- tailseq/f )
    [ f over ] dip [
        [ eq? ] curry find rot drop
    ] with find drop [ tail ] [ 2drop f ] if ; inline

TUPLE: cl-symbol { name string } ;
