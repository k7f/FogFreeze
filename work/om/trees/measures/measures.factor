! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors arrays grouping kernel locals math om.rhythm
       om.rhythm.onsets om.series sequences ;
IN: om.trees.measures

TUPLE: meter { num number } { den number } ;

INSTANCE: meter rhythm-duration

PREDICATE: measure < rhythm duration>> meter? ;

! _________________
! build-one-measure

<PRIVATE
:: (create-measure-element) ( onsets start duration -- relt )
    onsets [ duration 1 + 1array ] [ start global>local ] if-empty
    duration <rhythm-element> ; inline

:: (create-measure) ( onsets beats duration -- relts )
    beats 2 <clumps> [
        first2 [ onsets over ] dip trim-between*
        swap duration (create-measure-element)
    ] map fuse-rests-and-ties ; inline

: (create-beats) ( num den -- beats duration )
    1 swap / [ <repetition> 1 swap dx->x ] keep ; inline
PRIVATE>

: <measure> ( onsets num den -- measure )
    [ meter boa nip ] [ (create-beats) (create-measure) ] 3bi rhythm boa ;
