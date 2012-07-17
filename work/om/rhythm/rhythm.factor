! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors addenda.errors addenda.math addenda.sequences arrays assocs
       classes combinators fry grouping kernel lexer locals make math
       math.functions math.parser om.rhythm.meter om.rhythm.onsets om.series
       parser prettyprint prettyprint.backend prettyprint.custom
       prettyprint.sections sequences words ;
IN: om.rhythm

MIXIN: rhythm

UNION: rhythm-duration number meter ;

TUPLE: rhythm-tree
    { duration maybe{ rhythm-duration } }
    { division sequence } ;

UNION: rhythm-element number rhythm-tree ;

INSTANCE: number rhythm
INSTANCE: rhythm-tree rhythm

! _______________
! rhythm protocol

GENERIC: >rhythm-element ( rhm -- relt )
GENERIC: clone-rhythm ( rhm -- cloned )

GENERIC: <rhythm> ( dur dvn exemplar -- rhm )

GENERIC: get-duration ( rhm -- dur )

M: rational    get-duration ( num -- dur ) abs ; inline
M: float       get-duration ( num -- dur ) abs round >integer ; inline
M: sequence    get-duration ( seq -- dur ) first >rational abs ; inline
M: rhythm-tree get-duration ( rtree -- dur ) duration>> >rational ; inline

! ________________
! >rhythm-duration

GENERIC: >rhythm-duration ( obj -- dur )

M: number >rhythm-duration ( num -- dur ) ;
M: word   >rhythm-duration ( wrd -- dur ) execute( -- dur ) ;
M: object >rhythm-duration ( obj -- dur ) >meter ;

! ________________
! ?change-division

: ?change-division ( ... rtree quot: ( ... value -- ... value' ? ) -- ... rtree ? )
    over [ [ division>> ] dip call ] dip swap
    [ swap >>division t ] [ nip f ] if ; inline

! _____________
! <rhythm-tree>

<PRIVATE
: (create-rhythm) ( dur dvn -- rtree )
    [ -1 1array ] [
        [ >rhythm-element ] map
    ] if-empty
    over t eq? [
        nip [ 0 [ get-duration + ] reduce ] keep
    ] [
        over [ [ >rhythm-duration ] dip ] when
    ] if rhythm-tree boa ; inline
PRIVATE>

: <rhythm-tree> ( dur dvn -- rtree )
    dup sequence? [ (create-rhythm) ] [ nip class-of invalid-input ] if ;

! _____________
! >rhythm-tree<

: >rhythm-tree< ( rtree -- dur dvn ) [ duration>> ] [ division>> ] bi ;

! ________
! <rhythm>

M: rhythm-tree <rhythm> ( dur dvn exemplar -- rtree ) drop <rhythm-tree> ;

! _______________
! >rhythm-element

M: rhythm-element  >rhythm-element ( relt -- relt ) ;
M: proper-sequence >rhythm-element ( seq -- relt ) first2 <rhythm-tree> ;

! ____________
! clone-rhythm

<PRIVATE
GENERIC: (clone-rhythm) ( obj -- cloned )

M: object (clone-rhythm) ( obj -- cloned ) clone ; inline

M: rhythm-tree (clone-rhythm) ( rtree -- rtree' )
    (clone) [ clone ] change-duration
    [ [ (clone-rhythm) ] map ] change-division ; inline
PRIVATE>

M: rhythm-tree clone-rhythm ( rtree -- rtree' ) (clone-rhythm) ; inline
M: number clone-rhythm ( num -- num ) ; inline

! _____________
! onsets>rhythm

<PRIVATE
: (?attach-endpoint) ( onsets total -- onsets' )
    [ dup last ] [ 1 + ] bi* {
        { [ 2dup neg = ] [ nip over set-last ] }
        { [ 2dup = ] [ 2drop ] }
        [ nip suffix ]
    } cond ; inline

: (?split-heuristically) ( dvn -- dvn'/f )
    [ [ 0 < -1 1 ? ] map ]
    [ [ abs ] map ] bi {
        {
            [ dup { 2 2 2 3 3 } sequence= ]
            [ drop 3 cut [ 2 swap rhythm-tree boa ] [ first2 ] bi* 3array ]
        } {
            [ dup { 3 3 2 2 2 } sequence= ]
            [ drop 2 cut [ first2 ] [ 2 swap rhythm-tree boa ] bi* 3array ]
        } {
            [ dup { 3 2 2 2 3 } sequence= ]
            [ drop [ first ] [ 1 4 rot <slice> >array 2 swap rhythm-tree boa ] [ last ] tri 3array ]
        } {
            [ dup { 3. 2 2 2 3 } sequence= ]
            [ drop [ first >float ] [ 1 4 rot <slice> >array 2 swap rhythm-tree boa ] [ last ] tri 3array ]
        } {
            [ dup { 3 3 4 2 } sequence= ]
            [ drop first4 [ 2 * ] dip 2array 2 swap rhythm-tree boa 3array ]
        } {
            [ dup { 4 2 3 3 } sequence= ]
            [ drop first4 [ [ 2 * ] dip 2array 2 swap rhythm-tree boa ] 2dip 3array ]
        } {
            [ dup { 2 4 3 3 } sequence= ]
            [ drop first4 [ 2 * 2array 2 swap rhythm-tree boa ] 2dip 3array ]
        } {
            [ dup { 3 3 2 4 } sequence= ]
            [ drop first4 2 * 2array 2 swap rhythm-tree boa 3array ]
        } {
            [ dup { 3 1 1 1 } sequence= ]
            [ drop first4 3array 1 swap rhythm-tree boa 2array ]
        } {
            [ dup { 3. 1 1 1 } sequence= ]
            [ drop first4 3array 1 swap rhythm-tree boa [ >float ] dip 2array ]
        } {
            [ dup { 1 1 1 3 } sequence= ]
            [ drop first4 [ 3array 1 swap rhythm-tree boa ] dip 2array ]
        }
        [ 2drop f ]
    } cond ; inline

: (?unbox-note) ( rtree -- rtree/num )
    dup division>> dup ?length 1 =
    [ nip first ] [ drop ] if ; inline
PRIVATE>

: onsets>rhythm ( onsets -- rtree )
    dup first abs 1 = [ onsets>durations* ] [
        1 prefix onsets>durations*
        dup [ first >float ] keep set-first
    ] if [ (?split-heuristically) dup ] keep ?
    1 swap rhythm-tree boa ;

! _______________
! absolute-rhythm

: absolute-rhythm ( onsets total -- rtree )
    (?attach-endpoint) onsets>rhythm ;

: absolute-rhythm-element ( onsets total -- relt )
    absolute-rhythm (?unbox-note) ;

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

: ?fuse-notes-deep ( relts -- relts' ? )
    dup empty? [ f ] [
        unclip-slice {
            { [ dup rhythm-tree? ] [ [ ?fuse-notes-deep ] ?change-division ] }
            { [ dup 0 < ] [ f ] }
            [
                [
                    [ float? ] [ truncate >integer + ] reduce-head dup
                ] keep = not
            ]
        } cond
        [ [ ?fuse-notes-deep swap ] dip prefix swap ] dip or
    ] if ;

: fuse-notes-deep ( relts -- relts' )
    ?fuse-notes-deep drop ;

! _______________
! fuse-rests-deep

<PRIVATE
: (rest?) ( relt -- ? )
    dup number? [ 0 < ] [ drop f ] if ; inline

: (?unbox-rest) ( rtree -- rtree' ? )
    dup duration>> dup number? [
        over division>> dup ?length 1 = [
            first (rest?) [ neg nip t ] [ drop f ] if
        ] [ 2drop f ] if
    ] [ drop f ] if ; inline

: (?unbox-rests-deep) ( relts -- relts' ? )
    f swap [
        dup rhythm-tree? [
            (?unbox-rest) [
                [ (?unbox-rests-deep) ] ?change-division
            ] unless* swap [ or ] dip
        ] when
    ] map swap ;

: (?fuse-rests-deep) ( relts -- relts' ? )
    dup empty? [ f ] [
        unclip-slice {
            { [ dup rhythm-tree? ] [ [ (?fuse-rests-deep) ] ?change-division ] }
            { [ dup 0 > ] [ f ] }
            [
                [
                    [ dup integer? [ 0 < ] [ drop f ] if ]
                    [ + ] reduce-head dup
                ] keep = not
            ]
        } cond
        [ [ (?fuse-rests-deep) swap ] dip prefix swap ] dip or
    ] if ;
PRIVATE>

: ?fuse-rests-deep ( relts -- relts' ? )
    (?fuse-rests-deep) [ (?unbox-rests-deep) ] dip or ;

: fuse-rests-deep ( relts -- relts' )
    ?fuse-rests-deep drop ;

! _________
! <measure>

PREDICATE: measure < rhythm-tree duration>> meter? ;

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
    [ <meter> nip ] [ (create-beats) (create-measure) ] 3bi rhythm-tree boa ;

! ____________
! zip-measures

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

: zip-measures ( durs tsigs -- rtree )
    [ swap (durs>onsets) ]
    [ nip (tsigs>bars) ] 2bi
    [ (zip-measure) ] 2curry map-index
    f swap rhythm-tree boa ;

! __________
! map-rhythm

: map-rhythm ( ... relt quot: ( ... value -- ... value' ) -- ... relt' )
    over rhythm-tree? [
        swap clone
        [ swap [ map-rhythm ] curry map ] change-division
    ] [ call ] if ; inline recursive

: map-rhythm! ( ... relt quot: ( ... value -- ... value' ) -- ... relt' )
    over rhythm-tree? [
        swap
        [ swap [ map-rhythm! ] curry map! ] change-division
    ] [ call ] if ; inline recursive

! _______________
! map-rests>notes

GENERIC: map-rests>notes ( obj -- obj' )
GENERIC: map-rests>notes! ( obj -- obj' )

<PRIVATE
: (?rests>notes-out) ( value -- value'/f )
    dup integer? [
        dup 0 < [ neg ] [ drop f ] if
    ] [ drop f ] if ; inline

: (?rests>notes-in) ( value -- value'/f )
    dup integer? [
        dup 0 > [ drop f ] [ abs >float ] if
    ] [ abs ] if ; inline

: (?rests>notes) ( in? value -- in?' value' )
    [
        swap [ (?rests>notes-in) ]
        [ (?rests>notes-out) ] if dup dup
    ] keep ? ; inline
PRIVATE>

M: number map-rests>notes ( value -- value' )
    dup integer? [ abs ] when ;

M: rhythm-tree map-rests>notes ( rtree -- rtree' )
    f swap [ (?rests>notes) ] map-rhythm nip ;

M: number map-rests>notes! ( value -- value' )
    dup integer? [ abs ] when ;

M: rhythm-tree map-rests>notes! ( rtree -- rtree' )
    f swap [ (?rests>notes) ] map-rhythm! nip ;

! _______________
! map-notes>rests

GENERIC: map-notes>rests ( obj -- obj' )
GENERIC: map-notes>rests! ( obj -- obj' )

<PRIVATE
: (?notes>rests-out) ( value -- value'/f )
    dup integer? [
        dup 0 > [ neg ] [ drop f ] if
    ] [ drop f ] if ; inline

: (?notes>rests-in) ( value -- value'/f )
    dup integer? [
        dup 0 > [ neg ] [ drop f ] if
    ] [ neg round >integer ] if ; inline

: (?notes>rests) ( in? value -- in?' value' )
    [
        swap [ (?notes>rests-in) ]
        [ (?notes>rests-out) ] if dup dup
    ] keep ? ; inline
PRIVATE>

M: number map-notes>rests ( value -- value' )
    dup integer? [ dup 0 > [ neg ] when ] when ;

M: rhythm-tree map-notes>rests ( rtree -- rtree' )
    f swap [ (?notes>rests) ] map-rhythm nip ;

M: number map-notes>rests! ( value -- value' )
    dup integer? [ dup 0 > [ neg ] when ] when ;

M: rhythm-tree map-notes>rests! ( rtree -- rtree' )
    f swap [ (?notes>rests) ] map-rhythm! nip ;

! __________________
! submap-notes>rests

GENERIC# submap-notes>rests  1 ( obj places -- obj' )
GENERIC# submap-notes>rests! 1 ( obj places -- obj' )

M: number submap-notes>rests ( value places -- value' )
    drop map-notes>rests ; inline

M: number submap-notes>rests! ( value places -- value' )
    drop map-notes>rests! ; inline

! _________________
! rhythm-substitute

: rhythm-substitute ( relt assoc -- relt' )
    [ ?at drop ] curry map-rhythm ;

: rhythm-substitute! ( relt assoc -- relt )
    [ ?at drop ] curry map-rhythm! ;

! ____________
! rhythm-atoms

<PRIVATE
: (rhythm-atoms) ( relt -- )
    dup rhythm-tree? [ division>> [ (rhythm-atoms) ] each ] [ , ] if ;
PRIVATE>

GENERIC: rhythm-atoms ( obj -- atoms )

M: number rhythm-atoms ( num -- atoms ) 1array ;

M: rhythm-tree rhythm-atoms ( rtree -- atoms )
    [ division>> [ (rhythm-atoms) ] each ] { } make ;

! ____________
! {< >} syntax

DEFER: {<

<PRIVATE
SYMBOLS: (SEE) (SEP) (DIV) ;

: (parse-state?) ( obj -- ? )
    { (SEE) (SEP) (DIV) } member? ; inline

: (parse-left-brace) ( -- relt/* )
    V{ } clone \ {< execute-parsing ?first
    [ "inner syntax" invalid-input ] unless* ; inline

: (?keep-state) ( state -- state/* )
    dup (DIV) = [ drop "unexpected \"><\"" invalid-input ] when ; inline

: (element-or-meter) ( token -- relt/dur/* state )
    {
        { [ dup "{<" = ] [ drop (parse-left-brace) (DIV) ] }
        { [ dup "><" = ] [ drop (SEP) (DIV) ] }
        { [ dup "f" = ] [ drop f (SEP) ] }
        { [ dup "t" = ] [ drop t (SEP) ] }
        [ dup string>number [ nip (SEE) ] [ >meter (SEP) ] if* ]
    } cond ; inline

: (element-or-error) ( state token -- state' relt/* )
    {
        { [ dup "{<" = ] [ 2drop (parse-left-brace) ] }
        { [ dup "><" = ] [ drop (?keep-state) ] }
        [ nip dup string>number [ nip ] [ invalid-input ] if* ]
    } cond (DIV) swap ; inline

: (empty-tail) ( car -- car' cdr )
    {
        { [ dup meter? ] [ -1 ] }
        { [ dup (parse-state?) ] [ drop 1 -1 ] }
        [ 1 swap ]
    } cond 1array ; inline

: (empty-head) ( car -- car' ) drop 1 ; inline

: (deferred-tail) ( cdr -- cdr' ) rest [ -1 1array ] when-empty ; inline

: (parse-postprocess) ( car cdr -- car' cdr' )
    [ (empty-tail) ] [
        dup first (parse-state?) [ (deferred-tail) ] [
            over rhythm-element? [ swap prefix 1 swap ] when
        ] if
        [ dup (parse-state?) [ (empty-head) ] when ] dip
    ] if-empty ;

: (parse-rhythm) ( accum -- accum )
    scan-token dup ">}" = [ drop t -1 1array ] [
        (element-or-meter) ">}" [ (element-or-error) ] map-tokens
        nip (parse-postprocess)
    ] if <rhythm-tree> suffix! ;
PRIVATE>

SYMBOL: >} delimiter

SYNTAX: {< (parse-rhythm) ;

! _________
! unparsing

<PRIVATE
: (pprint-numeric) ( num -- )
    dup 1 = [ drop ] [ pprint* "><" text ] if ;

! meter unparses to a num//den only inside rhythm literal,
! outside, generic tuple unparsing is used
: (pprint-meter) ( mtr -- )
    [ num>> ] [ den>> ] bi
    [ unparse ] bi@ "//" glue text ;

: (pprint-duration) ( rtree -- )
    duration>> {
        { [ dup number? ] [ (pprint-numeric) ] }
        { [ dup meter? ] [ (pprint-meter) ] }
        [ pprint* ]
    } cond ;

: (pprint-unit-rest?) ( dvn -- ? )
    [ t ] [
        dup length 1 = [ first -1 = ] [ drop f ] if
    ] if-empty ;

: (pprint-empty?) ( rtree -- ? )
    >rhythm-tree< swap 1 =
    [ (pprint-unit-rest?) ] [ drop f ] if ;

: (pprint-division) ( rtree -- )
    division>> dup (pprint-unit-rest?)
    [ drop ] [ pprint-elements ] if ;
PRIVATE>

M: rhythm-tree pprint* ( rtree -- )
    [
        <flow \ {< pprint-word t <inset
        dup (pprint-empty?) [ drop ] [
            [ (pprint-duration) ]
            [ (pprint-division) ] bi
        ] if block>
        \ >} pprint-word block>
    ] check-recursion ;
