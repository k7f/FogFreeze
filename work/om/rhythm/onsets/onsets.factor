! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: kernel math math.functions om.series sequences ;
IN: om.rhythm.onsets

! ______________________
! make-proportional-cell

: ratios>integers ( durations -- durations' )
    dup [ denominator ] [ lcm ] map-reduce abs [ * ] curry map ; inline

: ratios>integers! ( durations -- durations )
    dup [ denominator ] [ lcm ] map-reduce abs [ * ] curry map! ; inline

! _____________
! x-dx-pause-ok

: onsets>durations ( onsets -- durations )
    [ [ abs ] map x->dx ] keep
    [ 0 > [ neg ] unless ] 2map ;

: onsets>durations* ( onsets -- durations )
    onsets>durations ratios>integers ;

! _____________
! dx-x-pause-ok

: durations>onsets ( start durations -- onsets )
    [ [ abs ] map dx->x ] keep 1 suffix
    [ 0 > [ neg ] unless ] 2map ;

! _________________
! build-local-times

: global>local ( global-onsets global-start -- local-onsets )
    1 - [
        over 0 > [ - ] [ + ] if
    ] curry map ;

! ____________________
! get-onsettime-before

: last-before ( onsets time -- onset/f )
    [ swap abs > ] curry find-last nip ;

! _____________________
! filter-events-between

: trim-between ( onsets start stop -- slice/f )
    [
        over [ abs <= ] with find drop
        [ tail-slice ] [ drop f ] if*
    ] [
        over [ abs >= ] with find-last drop
        [ 1 + head-slice ] [ drop f ] if*
    ] bi* ;

<PRIVATE
: (between-with-rest) ( onsets start trimmed -- result )
    2dup first = [ nip swap like ] [
        2over last-before [
            0 < [
                [ neg swap 1sequence ] dip append
            ] [ nip swap like ] if
        ] [ nip swap like ] if*
    ] if ; inline

: (empty-with-rest) ( onsets start -- result )
    2dup last-before [
        0 < [ neg swap 1sequence ] [ 2drop f ] if
    ] [ 2drop f ] if* ; inline
PRIVATE>

: trim-between* ( onsets start stop -- onsets'/f )
    2over [ trim-between ] 2dip rot
    [ (empty-with-rest) ] [ (between-with-rest) ] if-empty ;
