! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors addenda.sequences arrays combinators fry grouping kernel
       locals math math.functions om.rhythm.onsets om.series sequences ;
IN: om.rhythm

MIXIN: rhythm-duration
MIXIN: rhythm-element

TUPLE: rhythm { duration maybe: rhythm-duration } { division sequence } ;

INSTANCE: number rhythm-duration

INSTANCE: number rhythm-element
INSTANCE: rhythm rhythm-element

<PRIVATE
: (?attach-endpoint) ( onsets total -- onsets' )
    [ dup last ] [ 1 + ] bi* {
        { [ 2dup neg = ] [ nip over set-last ] }
        { [ 2dup = ] [ 2drop ] }
        [ nip suffix ]
    } cond ; inline

! _________________________
! better-predefined-subdiv?

: (?split-heuristically) ( dvn -- dvn'/f )
    [ [ 0 < -1 1 ? ] map ]
    [ [ abs ] map ] bi {
        {
            [ dup { 2 2 2 3 3 } sequence= ]
            [ drop 3 cut [ 2 swap rhythm boa ] [ first2 ] bi* 3array ]
        } {
            [ dup { 3 3 2 2 2 } sequence= ]
            [ drop 2 cut [ first2 ] [ 2 swap rhythm boa ] bi* 3array ]
        } {
            [ dup { 3 2 2 2 3 } sequence= ]
            [ drop [ first ] [ 1 4 rot <slice> >array 2 swap rhythm boa ] [ last ] tri 3array ]
        } {
            [ dup { 3. 2 2 2 3 } sequence= ]
            [ drop [ first >float ] [ 1 4 rot <slice> >array 2 swap rhythm boa ] [ last ] tri 3array ]
        } {
            [ dup { 3 3 4 2 } sequence= ]
            [ drop first4 [ 2 * ] dip 2array 2 swap rhythm boa 3array ]
        } {
            [ dup { 4 2 3 3 } sequence= ]
            [ drop first4 [ [ 2 * ] dip 2array 2 swap rhythm boa ] 2dip 3array ]
        } {
            [ dup { 2 4 3 3 } sequence= ]
            [ drop first4 [ 2 * 2array 2 swap rhythm boa ] 2dip 3array ]
        } {
            [ dup { 3 3 2 4 } sequence= ]
            [ drop first4 2 * 2array 2 swap rhythm boa 3array ]
        } {
            [ dup { 3 1 1 1 } sequence= ]
            [ drop first4 3array 1 swap rhythm boa 2array ]
        } {
            [ dup { 3. 1 1 1 } sequence= ]
            [ drop first4 3array 1 swap rhythm boa [ >float ] dip 2array ]
        } {
            [ dup { 1 1 1 3 } sequence= ]
            [ drop first4 [ 3array 1 swap rhythm boa ] dip 2array ]
        }
        [ 2drop f ]
    } cond ; inline

: (?unbox) ( rhm -- rhm/num )
    dup division>> dup ?length 1 =
    [ nip first ] [ drop ] if ; inline
PRIVATE>

: onsets>rhythm ( onsets -- rhm )
    dup first abs 1 = [ onsets>durations* ] [
        1 prefix onsets>durations*
        dup [ first >float ] keep set-first
    ] if [ (?split-heuristically) dup ] keep ?
    1 swap rhythm boa ;

: <rhythm> ( onsets total -- rhm )
    (?attach-endpoint) onsets>rhythm ;

: <rhythm-element> ( onsets total -- relt )
    <rhythm> (?unbox) ;

! ________________________________________
! fuse-pauses-and-tied-notes-between-beats

<PRIVATE
: (fuse-more-rest?) ( beat -- ? )
    dup number? [
        dup float? [ drop t ] [ 0 < ] if
    ] [ drop f ] if ; inline

: (fuse-next-rest) ( ndx relts beat -- ndx' newelt )
    swap '[
        [ 1 + ] dip over _ ?nth dup (fuse-more-rest?) [
            abs truncate >integer - t
        ] [ drop f ] if
    ] loop ; inline

: (fuse-next-note) ( ndx relts beat -- ndx' newelt )
    swap '[
        [ 1 + ] dip over _ ?nth dup float? [
            truncate >integer + t
        ] [ drop f ] if
    ] loop ; inline

: (fuse-next) ( ndx relts -- ndx' newelt )
    2dup ?nth dup number? [
        dup 0 < [ (fuse-next-rest) ] [ (fuse-next-note) ] if
    ] [ nip [ 1 + ] dip ] if ; inline
PRIVATE>

: fuse-rests-and-ties ( relts -- relts' )
    0 swap [ length [ over > ] curry ]
    [ [ (fuse-next) ] curry ]
    [ ] tri produce-as nip ;

! _______
! measure

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
