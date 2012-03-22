! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors arrays kernel math math.functions om.rhythm om.rhythm.meter
       om.rhythm.transformer refs sequences ;
IN: om.trees

! ______
! mktree

<PRIVATE
: (total-duration) ( durs -- dur )
    0 [ abs + ] reduce ; inline

: (count-measures) ( durs tsigs -- n )
    [ (total-duration) ] [ first2 ] bi*
    [ / ] [ * ] bi*
    dup integer? [ truncate 1 + ] unless ; inline
PRIVATE>

: mktree ( durs tsigs -- rhm )
    dup first sequence?
    [ 2dup (count-measures) swap <repetition> ] unless
    zip-measures ;

! __________
! reducetree

<PRIVATE
: (reducetree) ( relts -- relts' )
    [ ?fuse-notes-deep [ ?fuse-rests-deep ] dip or [ sift ] dip ] loop ;
PRIVATE>

: reducetree ( rhm -- rhm' )
    >rhythm-element dup rhythm? [
        [ (reducetree) ] change-division
    ] when ;

! __________
! pulsemaker

<PRIVATE
: (pulsemaker) ( nums dens pulses -- rhm )
    [ over [ [ <meter> ] 2map ] dip ] dip
    [ dup number? [ 1array ] when <rhythm> ] 2map
    [ 1array <rhythm> ] 2map
    f swap <rhythm> ;
PRIVATE>

: pulsemaker ( nums dens pulses -- rhm )
    [
        length [
            over number? [ swap <repetition> ] [ drop ] if
        ] curry bi@
    ] keep (pulsemaker) ;

! _______
! tietree

GENERIC: tietree ( relt -- relt' )

M: number tietree ( num -- num' )
    dup 0 < [ neg >float ] when ;

M: rhythm tietree ( rhm -- rhm' )
    [ [ tietree ] map ] change-division ;

! ____________
! remove-rests

<PRIVATE
: (?transform-rest-out) ( ref -- value/f )
    value>> dup integer? [
        dup 0 < [ neg ] [ drop f ] if
    ] [ drop f ] if ; inline

: (?transform-rest-in) ( ref -- value/f )
    value>> dup integer? [
        dup 0 > [ drop f ] [ abs >float  ] if
    ] [ abs ] if ; inline

: (?transform-rest) ( in? ref -- in?' ref' )
    swap over [
        [ (?transform-rest-in) ]
        [ (?transform-rest-out) ] if
        [ dup ] [ f f ] if*
    ] dip [ set-ref ] keep ; inline
PRIVATE>

: transform-rests ( refs -- refs' )
    f swap [ (?transform-rest) ] map nip ;

<PRIVATE
: (?remove-rest-out) ( value -- value'/f )
    dup integer? [
        dup 0 < [ neg ] [ drop f ] if
    ] [ drop f ] if ; inline

: (?remove-rest-in) ( value -- value'/f )
    dup integer? [
        dup 0 > [ drop f ] [ abs >float ] if
    ] [ abs ] if ; inline

: (?remove-rest) ( in? value -- in?' value' )
    [
        swap [ (?remove-rest-in) ]
        [ (?remove-rest-out) ] if dup dup
    ] keep ? ; inline
PRIVATE>

GENERIC: remove-rests ( relt -- relt' )

M: number remove-rests ( value -- value' )
    dup integer? [ abs ] when ;

M: rhythm remove-rests ( rhm -- rhm' )
    f swap [ (?remove-rest) ] map-rhythm nip ;

GENERIC: remove-rests! ( relt -- relt' )

M: number remove-rests! ( value -- value' )
    dup integer? [ abs ] when ;

M: rhythm remove-rests! ( rhm -- rhm' )
    f swap [ (?remove-rest) ] map-rhythm! nip ;
