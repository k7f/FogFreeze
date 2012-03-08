! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors addenda.errors addenda.sequences arrays classes combinators
       fry grouping kernel locals math math.functions om.rhythm.meter
       om.rhythm.onsets om.series sequences ;
IN: om.rhythm

MIXIN: rhythm-duration
MIXIN: rhythm-element

TUPLE: rhythm { duration maybe: rhythm-duration } { division sequence } ;

INSTANCE: number rhythm-duration
INSTANCE: meter  rhythm-duration

INSTANCE: number rhythm-element
INSTANCE: rhythm rhythm-element

: >rhythm-duration ( obj -- dur )
    dup number? [ >meter ] unless ;

GENERIC: >rhythm-element ( obj -- relt )

<PRIVATE
GENERIC: fullratio ( obj -- rat )

M: rational fullratio ( n   -- rat ) ;
M: float    fullratio ( n   -- rat ) round >integer ;
M: sequence fullratio ( seq -- rat ) first2 / ;
M: meter    fullratio ( mtr -- dur ) [ num>> ] [ den>> ] bi / ; inline

GENERIC: (subtree-extent) ( obj -- dur )

M: rational (subtree-extent) ( n   -- dur ) abs ; inline
M: float    (subtree-extent) ( n   -- dur ) abs round >integer ; inline
M: sequence (subtree-extent) ( seq -- dur ) first fullratio abs ; inline
M: rhythm   (subtree-extent) ( rtm -- dur ) duration>> fullratio ; inline

: (create-rhythm) ( dur dvn -- relt )
    [ >rhythm-element ] map over [
        [ >rhythm-duration ] dip
    ] [
        nip [ 0 [ (subtree-extent) + ] reduce ] keep
    ] if rhythm boa ; inline
PRIVATE>

: <rhythm> ( dur dvn -- relt )
    dup sequence? [ (create-rhythm) ] [ nip class-of invalid-input ] if ;

! _________
! resolve-?

M: rhythm-element  >rhythm-element ( relt -- relt ) ;
M: proper-sequence >rhythm-element ( seq -- relt ) first2 <rhythm> ;

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

: absolute-rhythm ( onsets total -- rhm )
    (?attach-endpoint) onsets>rhythm ;

: absolute-rhythm-element ( onsets total -- relt )
    absolute-rhythm (?unbox) ;

! ___________________
! fuse-rests-and-ties

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

! _______________
! fuse-notes-deep

: fuse-notes-deep ( relts -- relts' )
    dup empty? [
        unclip-slice {
            { [ dup rhythm? ] [ [ fuse-notes-deep ] change-division ] }
            { [ dup 0 < ] [ ] }
            [ [ float? ] [ truncate >integer + ] reduce-head ]
        } cond
        [ fuse-notes-deep ] dip prefix
    ] unless ;

! _______________
! fuse-rests-deep

: fuse-rests-deep ( relts -- relts' )
    dup empty? [
        unclip-slice {
            { [ dup rhythm? ] [ [ fuse-rests-deep ] change-division ] }
            { [ dup 0 > ] [ ] }
            [ [ dup integer? [ 0 < ] [ drop f ] if ] [ + ] reduce-head ]
        } cond
        [ fuse-rests-deep ] dip prefix
    ] unless ;

! _______
! measure

PREDICATE: measure < rhythm duration>> meter? ;

! _________________
! build-one-measure

<PRIVATE
:: (create-measure-element) ( onsets start duration -- relt )
    onsets [ duration 1 + 1array ] [ start global>local ] if-empty
    duration absolute-rhythm-element ; inline

:: (create-measure) ( onsets beats duration -- relts )
    beats 2 <clumps> [
        first2 [ onsets over ] dip trim-between*
        swap duration (create-measure-element)
    ] map fuse-rests-and-ties ; inline

: (create-beats) ( num den -- beats duration )
    1 swap / [ <repetition> 1 swap dx->x ] keep ; inline
PRIVATE>

: <measure> ( onsets num den -- measure )
    [ <meter> nip ] [ (create-beats) (create-measure) ] 3bi rhythm boa ;

! ____________
! simple->tree

<PRIVATE
: (durs>onsets) ( durs -- onsets )
    1 swap -100 suffix durations>onsets ; inline

: (tsigs>bars) ( tsigs -- bars )
    [ unclip-slice [ / ] reduce ] map 1 swap dx->x ; inline

: (trim-onsets) ( measure-ndx onsets bars -- onsets' )
    [ swap dup 1 + ] dip [ nth ] curry bi@ trim-between* ; inline

: (zip-measure) ( tsig measure-ndx onsets bars -- measure )
    [ (trim-onsets) ] 3keep nip nth global>local
    swap [ first ] [ second ] bi <measure> ; inline
PRIVATE>

: zip-measures ( durs tsigs -- rhm )
    [ swap (durs>onsets) ]
    [ nip (tsigs>bars) ] 2bi
    [ (zip-measure) ] 2curry map-index
    f swap rhythm boa ;
