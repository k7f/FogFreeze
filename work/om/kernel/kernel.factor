! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.errors addenda.sequences addenda.sequences.deep arrays classes
       combinators combinators.short-circuit grouping kernel locals macros
       math math.constants math.functions math.order math.primes.factors
       math.ranges math.statistics om.support quotations random sequences
       sequences.deep sequences.private words ;
IN: om.kernel

! ___________________
! om+ om* om- om/ om^

GENERIC: om+ ( obj1 obj2 -- result )
M: number   om+ ( obj num -- result ) [ + ] om-binop-number ;
M: sequence om+ ( obj seq -- result ) [ + ] om-binop-sequence ;

GENERIC: om* ( obj1 obj2 -- result )
M: number   om* ( obj num -- result ) [ * ] om-binop-number ;
M: sequence om* ( obj seq -- result ) [ * ] om-binop-sequence ;

GENERIC: om- ( obj1 obj2 -- result )
M: number   om- ( obj num -- result ) [ - ] om-binop-number ;
M: sequence om- ( obj seq -- result ) [ - ] om-binop-sequence ;

GENERIC: om/ ( obj1 obj2 -- result )
M: number   om/ ( obj num -- result ) [ / ] om-binop-number ;
M: sequence om/ ( obj seq -- result ) [ / ] om-binop-sequence ;

GENERIC: om^ ( obj1 obj2 -- result )
M: number   om^ ( obj num -- result ) [ ^ ] om-binop-number ;
M: sequence om^ ( obj seq -- result ) [ ^ ] om-binop-sequence ;

! ____
! om-e

GENERIC: om-e ( obj -- result )

M: number   om-e ( num -- num' ) exp ; inline
M: sequence om-e ( seq -- seq' ) [ exp ] map ; inline

! ______
! om-log

GENERIC# om-log 1 ( obj &optionals -- result )

M: number om-log ( num &optionals -- num' )
    unpack1 [ [ log ] bi@ / ] [ log ] if* ;

M: sequence om-log ( seq &optionals -- seq' )
    unpack1 [
        log [ [ log ] dip / ] curry map
    ] [ [ log ] map ] if* ;

! ________
! om-round

<PRIVATE
: (approx-decimals) ( num-decimals n -- n' )
    over 0 > [ swap 10^ [ recip / round ] keep / ] [ nip round >integer ] if ;
PRIVATE>

GENERIC# om-round 1 ( obj &optionals -- obj' )

M: number om-round ( num &optionals -- num' )
    0 unpack2 swapd [ / ] when* (approx-decimals) ;

M: sequence om-round ( seq &optionals -- seq' )
    0 unpack2 [
        [ swapd / (approx-decimals) ] 2curry map
    ] [
        [ swap (approx-decimals) ] curry map
    ] if* ;

! ____
! om//

GENERIC: om// ( obj div -- quo rem )

M: number om// ( obj div -- quo rem )
    {
        { [ over number? ] [ cl-floor ] }
        {
            [ over sequence? ] [
                swap [ drop f f ] [
                    swap [ cl-floor 2array ] curry map flip first2
                ] if-empty
            ]
        }
        [ drop class-of invalid-input ]
    } cond ;

M: sequence om// ( obj divs -- quo rem )
    {
        {
            [ over number? ] [
                [ drop f f ] [
                    [ cl-floor 2array ] with map flip first2
                ] if-empty
            ]
        }
        {
            [ over sequence? ] [
                [ cl-floor 2array ] 2map
                [ f f ] [ flip first2 ] if-empty
            ]
        }
        [ drop class-of invalid-input ]
    } cond ;

! ______
! om-abs

GENERIC: om-abs ( obj -- result )

M: number   om-abs ( num -- num' ) abs ; inline
M: sequence om-abs ( seq -- seq' ) [ abs ] map ; inline

! _____________
! om-min om-max

GENERIC: om-min ( obj1 obj2 -- result )
M: number   om-min ( obj num -- result ) [ min ] om-binop-number ;
M: sequence om-min ( obj seq -- result ) [ min ] om-binop-sequence ;

GENERIC: om-max ( obj1 obj2 -- result )
M: number   om-max ( obj num -- result ) [ max ] om-binop-number ;
M: sequence om-max ( obj seq -- result ) [ max ] om-binop-sequence ;

! _________________
! list-min list-max

<PRIVATE
: (list-min) ( seq default -- num )
    swap [ dup atom? [ min ] [ drop ] if ] deep-each ;
PRIVATE>

GENERIC: list-min ( obj -- result )

M: sequence list-min ( seq -- num/f )
    dup [ atom? ] deep-find
    [ [ min ] deep-reduce ] [ drop f ] if* ;

M: object list-min ( obj -- obj ) ;

GENERIC: list-max ( obj -- result )

M: sequence list-max ( seq -- num/f )
    dup [ atom? ] deep-find
    [ [ max ] deep-reduce ] [ drop f ] if* ;

M: object list-max ( obj -- obj ) ;

! _________________
! tree-min tree-max

GENERIC# tree-min 1 ( obj &optionals -- result )

M: number tree-min ( num &optionals -- num' )
    unpack1 [ largest-float ] unless* min ;

M: sequence tree-min ( seq &optionals -- num )
    unpack1 [ largest-float ] unless* [ min ] deep-reduce ;

GENERIC# tree-max 1 ( obj &optionals -- result )

M: number tree-max ( num &optionals -- num' )
    unpack1 [ largest-float neg ] unless* max ;

M: sequence tree-max ( seq &optionals -- num )
    unpack1 [ largest-float neg ] unless* [ max ] deep-reduce ;

! _______
! om-mean

<PRIVATE
: (average-weighted) ( seq weights -- result )
    2dup [ length ] bi@ > [ over length 1.0 pad-tail ] when
    [ [ >float * ] [ + ] 2map-reduce ] [ sum ] bi / ;
PRIVATE>

GENERIC# om-mean 1 ( obj &optionals -- result )

M: sequence om-mean ( seq &optionals -- result )
    dup sequence? [ [ f ] when-empty ] [ drop f ] if
    [ (average-weighted) ] [ mean >float ] if* ;

! _________
! om-random

<PRIVATE
: (uniform-random-integer) ( low high -- result )
    2dup - zero? [ dup neg + + ] [
        [ max 1 + ] [ min ] 2bi [ - random ] keep +
    ] if ; inline
PRIVATE>

GENERIC: om-random ( low high -- result )

M: float om-random ( low high -- result ) uniform-random-float ;
M: ratio om-random ( low high -- result ) uniform-random-float ;

M: integer om-random ( low high -- result )
    over integer? [ (uniform-random-integer) ] [ uniform-random-float ] if ;

! ____________
! perturbation

<PRIVATE
! cf defun mulalea
: (perturbation) ( num percent -- result )
    [ neg ] [ >float ] bi uniform-random-float 1.0 + * ;
PRIVATE>

GENERIC: perturbation ( percent obj -- result )

M: number perturbation ( percent num -- result )
    {
        { [ over number? ] [ swap (perturbation) ] }
        { [ over sequence? ] [ swap [ (perturbation) ] with map ] }
        [ drop class-of invalid-input ]
    } cond ;

M: sequence perturbation ( percent seq -- result )
    {
        { [ over number? ] [ swap [ (perturbation) ] curry map ] }
        { [ over sequence? ] [ swap [ (perturbation) ] 2map ] }
        [ drop class-of invalid-input ]
    } cond ;

! ________
! om-scale

<PRIVATE
: (om-scale-unpack) ( &optionals obj -- minin maxin obj ? )
    [ 0 unpack2 [ 0 ] unless* 2dup = ] dip swap ; inline

: (om-scale) ( minout maxout minin maxin num -- num' )
    pick - [ over - ] 3dip [ swap - ] dip rot * swap / + ;
PRIVATE>

GENERIC# om-scale 1 ( minout maxout obj &optionals -- result )

M: number om-scale ( minout maxout num &optionals -- result )
    swap (om-scale-unpack) [
        2drop [ 2drop ] dip
    ] [ (om-scale) ] if ;

M: sequence om-scale ( minout maxout seq &optionals -- result )
    swap [ 3drop f ] [
        (om-scale-unpack) [
            2nip [ infimum ] [ supremum ] [ ] tri
            [ 2dup = [ [ drop 0 ] [ abs ] bi* ] when ] dip
        ] when
        [ [ [ rot ] 2dip rot (om-scale) ] 2curry 2curry ] dip swap map
    ] if-empty ;

! _____________
! g-scaling/sum

GENERIC: g-scaling/sum ( obj1 obj2 -- result )

<PRIVATE
: (g-scaling/sum-flat) ( flat-seq num -- flat-seq' )
    over sum / [ * ] curry map ; inline

: (g-scaling/sum-scalar) ( num1 num2 -- flat-seq )
    [ 1array ] dip (g-scaling/sum-flat) ; inline

: (g-scaling/sum-tree) ( seq num -- flat-seq )
    over [ 2drop f ] [
        first dup atom? [ drop (g-scaling/sum-flat) ] [
            over g-scaling/sum
            [ [ rest ] dip g-scaling/sum ] dip prefix
        ] if
    ] if-empty ; inline recursive
PRIVATE>

M: number g-scaling/sum ( obj num -- result )
    {
        { [ over number? ] [ (g-scaling/sum-scalar) ] }
        { [ over atom? ]   [ drop class-of invalid-input ] }
        [ (g-scaling/sum-tree) ]
    } cond ;

M: sequence g-scaling/sum ( obj seq -- result )
    {
        { [ dup empty? ] [ 2drop f ] }
        {
            [ over number? ] [
                dup first dup atom? [
                    [ drop 1array ] dip (g-scaling/sum-flat)
                ] [
                    [ over ] dip g-scaling/sum
                    [ rest g-scaling/sum ] dip prefix
                ] if
            ]
        }
        { [ over atom? ] [ drop class-of invalid-input ] }
        [
            over [ 2drop f ] [
                over [ first ] bi@ g-scaling/sum
                [ [ rest ] bi@ g-scaling/sum ] dip prefix
            ] if-empty
        ]
    } cond ; recursive

! ____________
! om-scale/sum

GENERIC# om-scale/sum 1 ( obj num -- result )

M: number om-scale/sum ( num1 num2 -- result )
    dup number? [ (g-scaling/sum-scalar) ] [ nip class-of invalid-input ] if ;

M: sequence om-scale/sum ( seq num -- result )
    dup number? [ (g-scaling/sum-tree) ] [ nip class-of invalid-input ] if ;

! _________
! factorize

GENERIC: factorize ( obj -- seq )

M: integer factorize ( num -- seq ) group-factors ;

! ___________
! reduce-tree

<PRIVATE
ERROR: (unknown-neutral-element) quot ;

GENERIC: (neutral-element) ( fun -- num/f )

M: word (neutral-element) ( sym -- num/f )
    { { \ + [ 0.0 ] }
      { \ * [ 1.0 ] }
      { \ min [ largest-float ] }
      { \ max [ largest-float neg ] }
      [ drop f ]
    } case ;

M: callable (neutral-element) ( quot: ( elt1 elt2 -- elt' ) -- num/f )
    { { [ + ] [ 0.0 ] }
      { [ * ] [ 1.0 ] }
      { [ min ] [ largest-float ] }
      { [ max ] [ largest-float neg ] }
      [ (unknown-neutral-element) ]
    } case ;

: (reduce-tree) ( obj quot: ( elt1 elt2 -- elt' ) identity -- result )
    swap {
        { [ pick number? ] [ call ] }
        { [ pick sequence? ] [ [ swap ] prepose deep-reduce ] }
        [ 2drop class-of invalid-input ]
    } cond ; inline

GENERIC# (reduce-tree-fun) 1 ( fun &optionals -- quot: ( elt1 elt2 -- elt' ) identity/f )

M: word (reduce-tree-fun) ( sym &optionals -- quot: ( elt1 elt2 -- elt' ) identity/f )
    [ dup (neutral-element) ] unless* [ 1quotation ] dip (reduce-tree-fun) ; inline

M: callable (reduce-tree-fun) ( quot: ( elt1 elt2 -- elt' ) &optionals -- quot: ( elt1 elt2 -- elt' ) identity/f )
    [ dup (neutral-element) ] unless* ; inline
PRIVATE>

MACRO: reduce-tree ( fun &optionals -- quot: ( obj -- result ) )
    (reduce-tree-fun) [ (reduce-tree) ] 2curry ;

! _____________
! interpolation

<PRIVATE
! FIXME >float is a hack against (a bug of?) ^ returning a fixnum for base equal 0
: (interpolation-point) ( begin end curve loc -- num )
    swap exp ^ >float [ over - ] dip * + ; inline

: (interpolation-samples) ( begin end curve num-samples -- seq )
    dup 1 > [
        [ 1 swap 1 - / ] keep iota [
            * [ 3dup ] dip (interpolation-point)
        ] with map [ 3drop ] dip
    ] [ drop 0.5 (interpolation-point) 1array ] if ;
PRIVATE>

GENERIC: interpolation ( curve num-samples begin end -- seq )

M: number interpolation ( curve num-samples begin end -- seq )
    {
        { [ over number? ] [ rot [ rot ] dip (interpolation-samples) ] }
        {
            [ over sequence? ] [
                 rot [ rot ] dip [ (interpolation-samples) ] 3curry map flip
            ]
        }
        [ drop 2nip class-of invalid-input ]
    } cond ; inline

M: sequence interpolation ( curve num-samples begin end -- seq )
    {
        {
            [ over number? ] [
                 rot [ rot ] dip [ (interpolation-samples) ] 2curry with map flip
            ]
        }
        {
            [ over sequence? ] [
                 rot [ rot ] dip [ (interpolation-samples) ] 2curry 2map flip
            ]
        }
        [ drop 2nip class-of invalid-input ]
    } cond ; inline

! ______
! rang-p

! FIXME choose a better name and make rang-p an alias

<PRIVATE
GENERIC# (rang-p-curry) 1 ( obj quot: ( elt1 elt2 -- ? ) -- quot: ( elt -- ? ) )

M: number (rang-p-curry) ( test-elt quot: ( elt1 elt2 -- ? ) -- quot: ( elt -- ? ) )
    curry ;

M: sequence (rang-p-curry) ( test-seq quot: ( elt1 elt2 -- ? ) -- quot: ( elt -- ? ) )
    [ with any? ] 2curry ;
PRIVATE>

MACRO: rang-p ( obj &optionals -- quot: ( seq -- seq' ) )
    [ = ] unpack-test&key (rang-p-curry) [ filter/indices ] curry ;

! ____________
! list-explode

<PRIVATE
: (explode-fill) ( src dst -- src dst )
    over [ [ 1array ] dip pick set-nth-unsafe ] each-index ; inline

: (explode-repeat) ( src dst |src| |dst| -- dst )
    [ 1 - ] bi@ [a,b] rot last 1array swap
    [ pick set-nth-unsafe ] with each ; inline

: (explode-extend) ( src |src| |dst| -- dst )
    [ nip { } new-sequence (explode-fill) ] 2keep (explode-repeat) ; inline

! FIXME add an OM-compatible variant, perhaps?
: (explode-partition) ( |src| |dst| -- sizes offsets )
    [ [0,b] swap ] keep / [ * round ] curry map
    [ [ rest-slice ] keep [ - ] over 2map-as ] keep ; inline

: (explode-chunk) ( src |chunk| offset -- src chunk )
    swap over + pick subseq ; inline

: (list-explode) ( src |src| |dst| -- dst )
    (explode-partition) [ (explode-chunk) ] 2map nip ; inline
PRIVATE>

GENERIC# list-explode 1 ( src |dst| -- array )

M: sequence list-explode ( src |dst| -- array )
    {
        { [ dup 1 <= ] [ drop >array ] }
        {
            [ [ dup length ] [ >integer ] bi* 2dup < ] [ (explode-extend) ]
        }
        { [ 2dup divisor? ] [ / group ] }
        [ (list-explode) ]
    } cond ;

! ___________
! list-filter

SYMBOLS: 'pass 'reject ;

<PRIVATE
GENERIC# (list-filter-fun) 1 ( fun mode -- quot: ( elt -- ? ) )

M: word (list-filter-fun) ( sym mode -- quot: ( elt -- ? ) )
    [ 1quotation ] dip (list-filter-fun) ;

M: callable (list-filter-fun) ( quot: ( elt -- ? ) mode -- quot: ( elt -- ? ) )
    'reject eq? [ [ not ] compose ] when ;
PRIVATE>

MACRO: list-filter ( fun mode -- quot: ( seq -- seq' ) )
    (list-filter-fun) [ deep-filter-atoms ] curry ;

! ____________
! table-filter

<PRIVATE
GENERIC# (table-filter-fun) 1 ( numcol fun mode -- quot: ( elt -- ? ) )

M: word (table-filter-fun) ( numcol sym mode -- quot: ( elt -- ? ) )
    [ 1quotation ] dip (table-filter-fun) ;

M: callable (table-filter-fun) ( numcol quot: ( elt -- ? ) mode -- quot: ( elt -- ? ) )
    'reject eq? [ [ not ] compose ] when
    swap [ swap nth ] curry prepose ;
PRIVATE>

MACRO: table-filter ( numcol fun mode -- quot: ( seq -- seq' ) )
    (table-filter-fun) [ filter ] curry ;

! ___________
! band-filter

<PRIVATE
: (in-range?) ( elt range -- ? )
    { [ first >= ] [ second <= ] } 2&& ; inline

GENERIC: (band-filter-fun) ( bounds -- quot: ( elt -- ? ) )

M: sequence (band-filter-fun) ( bounds -- quot: ( elt -- ? ) )
    [ [ (in-range?) ] with any? ] curry ;
PRIVATE>

MACRO: band-filter ( bounds mode -- quot: ( seq -- seq' ) )
    [ (band-filter-fun) ] dip [ list-filter ] 2curry ;

! ____________
! range-filter

<PRIVATE
: (next-range) ( ndx range-ndx ranges --  range-ndx' )
    dupd nth second rot <= [ 1 + ] when ; inline

: (range-test) ( range-ndx elt ndx ranges -- range-ndx' ? )
    [ nip swap ] dip dup length pick > [
        [ nth (in-range?) ] 3keep (next-range) swap
    ] [ drop nip f ] if ; inline

GENERIC# (range-filter-fun) 1 ( ranges mode -- quot: ( ndx elt ndx -- ndx' ? ) )

M: sequence (range-filter-fun) ( ranges mode -- quot: ( ndx elt ndx -- ndx' ? ) )
    'reject eq? [ [ (range-test) not ] ] [ [ (range-test) ] ] if curry ;
PRIVATE>

MACRO: range-filter ( ranges mode -- quot: ( seq -- seq' ) )
    (range-filter-fun) [ [ 0 ] 2dip filter-index nip ] curry ;

! __________
! posn-match

GENERIC: posn-match ( seq positions -- seq' )

M: integer posn-match ( seq position -- seq' )
    swap nth ;

M: sequence posn-match ( seq positions -- seq' )
    [ over 2dup bounds-check? [ nth ] [ 2drop f ] if ] deep-map-atoms nip ;

! ____
! pgcd

GENERIC: pgcd ( a b -- result )

<PRIVATE
:: (pgcd) ( a b -- result )
    a denominator b numerator *
    b denominator a numerator * gcd nip
    a denominator b denominator * / ;
PRIVATE>

M: ratio pgcd ( a b -- result )
    over rational? [ (pgcd) ] [ drop class-of invalid-input ] if ;

M: integer pgcd ( a b -- result )
    {
        { [ over integer? ] [ gcd nip ] }
        { [ over ratio? ] [ (pgcd) ] }
        [ drop class-of invalid-input ]
    } cond ;
