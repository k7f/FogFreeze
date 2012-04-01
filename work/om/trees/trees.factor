! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors addenda.sequences arrays kernel math math.functions
       om.lists om.rhythm om.rhythm.meter om.rhythm.transformer om.series
       refs sequences ;
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

GENERIC: transform-rests ( rt -- rt' )
M: rhythm-transformer transform-rests ( rt -- rt' ) map-rests>notes! ; inline

GENERIC: remove-rests ( relt -- relt' )
M: rhythm-element remove-rests ( relt -- relt' ) map-rests>notes! ; inline

! __________
! filtertree

GENERIC# transform-notes-flt 1 ( rt places -- rt' )
M: rhythm-transformer transform-notes-flt ( rt places -- rt' ) submap-notes>rests! ; inline

GENERIC# filtertree 1 ( relt places -- relt' )
M: rhythm-element filtertree ( relt places -- relt' ) submap-notes>rests! ; inline

! ____________
! group-pulses

<PRIVATE
: (non-tie-indices) ( atoms -- indices )
    [ float? not ] filter/indices ;

: (group-pulses) ( atoms indices -- pulses )
    dup first 0 = [ 0 prefix ] unless
    over length suffix
    x->dx 'linear group-list ;
PRIVATE>

: group-pulses ( rhm -- pulses )
    rhythm-atoms dup (non-tie-indices)
    [ drop f ] [ (group-pulses) ] if-empty ;

! ________
! n-pulses

: n-pulses ( rhm -- n )
    group-pulses [ first 0 > ] filter length ;
