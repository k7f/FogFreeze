! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.errors arrays assocs classes combinators kernel macros math
       math.functions quotations sequences strings words ;
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

MACRO: om-binop-number ( quot: ( elt1 elt2 -- elt' ) -- quot': ( obj num -- obj' ) )
    [
        {
            { [ pick number?   ] [ call      ] }
            { [ pick sequence? ] [ curry map ] }
            [ 2drop class-of invalid-input ]
        } cond
    ] curry  ;

MACRO: om-binop-sequence ( quot: ( elt1 elt2 -- elt' ) -- quot': ( obj seq -- seq' ) )
    [
        {
            { [ pick number?   ] [ with map ] }
            { [ pick sequence? ] [ 2map     ] }
            [ drop class-of invalid-input ]
        } cond
    ] curry ;

! __________
! cl-related

TUPLE: cl-symbol { name string } ;

MACRO: (cl-rounding) ( quot: ( num -- num' ) -- quot': ( num div -- quo rem ) )
    [ [ 2dup / ] dip call [ * - ] [ >integer ] bi swap ] curry ;

: cl-floor    ( num div -- quo rem ) [ floor    ] (cl-rounding) ;
: cl-round    ( num div -- quo rem ) [ round    ] (cl-rounding) ;
: cl-ceiling  ( num div -- quo rem ) [ ceiling  ] (cl-rounding) ;
: cl-truncate ( num div -- quo rem ) [ truncate ] (cl-rounding) ;

: cl-identity ( obj -- obj ) ;
