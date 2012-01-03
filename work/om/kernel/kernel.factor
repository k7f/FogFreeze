! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: arrays classes combinators ff.errors kernel locals math math.constants
       math.functions math.order math.primes.factors math.statistics namespaces
       om.support quotations random sequences sequences.deep words
       io prettyprint ;
IN: om.kernel

! _____________________________________
! 01-basicproject/functions/kernel.lisp

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

! &optionals: (base (exp 1))
GENERIC: om-log ( &optionals obj -- result )

M: number om-log ( &optionals num -- num' )
    swap &optional-unpack1
    [ [ log ] bi@ / ] [ log ] if* ;

M: sequence om-log ( &optionals seq -- seq' )
    swap &optional-unpack1 [
        log [ [ log ] dip / ] curry map
    ] [ [ log ] map ] if* ;

! ________
! om-round

<PRIVATE
: (approx-decimals) ( num-decimals n -- n' )
    over 0 > [ swap 10^ [ recip / round ] keep / ] [ nip round >integer ] if ;
PRIVATE>

! &optionals: (num-decimals 0) (divisor 1)
GENERIC: om-round ( &optionals obj -- obj' )

M: number om-round ( &optionals num -- num' )
    [ 0 &optional-unpack2 ] dip swap
    [ / ] when* (approx-decimals) ;

M: sequence om-round ( &optionals seq -- seq' )
    swap 0 &optional-unpack2 [
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
    swap [ dup branch? [ drop ] [ min ] if ] deep-each ;
PRIVATE>

GENERIC: list-min ( obj -- result )

M: sequence list-min ( seq -- num/f )
    dup [ branch? not ] deep-find
    [ [ min ] deep-reduce ] [ drop f ] if* ;

M: object list-min ( obj -- obj ) ;

GENERIC: list-max ( obj -- result )

M: sequence list-max ( seq -- num/f )
    dup [ branch? not ] deep-find
    [ [ max ] deep-reduce ] [ drop f ] if* ;

M: object list-max ( obj -- obj ) ;

! _________________
! tree-min tree-max

! &optionals (min MOST-POSITIVE-LONG-FLOAT)
GENERIC: tree-min ( &optionals obj -- result )

M: number tree-min ( &optionals num -- num' )
    swap &optional-unpack1 [ largest-float ] unless* min ;

M: sequence tree-min ( &optionals seq -- num )
    swap &optional-unpack1 [ largest-float ] unless* [ min ] deep-reduce ;

! &optionals (max MOST-NEGATIVE-LONG-FLOAT)
GENERIC: tree-max ( &optionals obj -- result )

M: number tree-max ( &optionals num -- num' )
    swap &optional-unpack1 [ largest-float neg ] unless* max ;

M: sequence tree-max ( &optionals seq -- num )
    swap &optional-unpack1 [ largest-float neg ] unless* [ max ] deep-reduce ;

! _______
! om-mean

<PRIVATE
: (average-weighted) ( seq weights -- result )
    2dup [ length ] bi@ > [ over length 1.0 pad-tail ] when
    [ [ >float * ] [ + ] 2map-reduce ] [ sum ] bi / ;
PRIVATE>

! &optionals: (weights 1)
GENERIC: om-mean ( &optionals obj -- result )

M: sequence om-mean ( &optionals seq -- result )
    over sequence? [ swap [ f ] when-empty ] [ nip f ] if
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
: (om-scale-unpack) ( &optionals minout maxout obj -- minout maxout minin maxin obj ? )
    [ rot 0 &optional-unpack2 [ 0 ] unless* 2dup = ] dip swap ;

: (om-scale) ( minout maxout minin maxin num -- num' )
    pick - [ over - ] 3dip [ swap - ] dip rot * swap / + ;
PRIVATE>

! &optionals: (minin 0) (maxin 0)
GENERIC: om-scale ( &optionals minout maxout obj -- result )

M: number om-scale ( &optionals minout maxout num -- result )
    (om-scale-unpack) [
        2drop [ 2drop ] dip
    ] [ (om-scale) ] if ;

M: sequence om-scale ( &optionals minout maxout seq -- result )
    [ 3drop f ] [
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
        first dup branch? [
            over g-scaling/sum
            [ [ rest ] dip g-scaling/sum ] dip prefix
        ] [ drop (g-scaling/sum-flat) ] if
    ] if-empty ; inline recursive
PRIVATE>

M: number g-scaling/sum ( obj num -- result )
    {
        { [ over number? ] [ (g-scaling/sum-scalar) ] }
        { [ over branch? ] [ (g-scaling/sum-tree) ] }
        [ drop class-of invalid-input ]
    } cond ;

M: sequence g-scaling/sum ( obj seq -- result )
    {
        { [ dup empty? ] [ 2drop f ] }
        {
            [ over number? ] [
                dup first dup branch? [
                    [ over ] dip g-scaling/sum
                    [ rest g-scaling/sum ] dip prefix
                ] [
                    [ drop 1array ] dip (g-scaling/sum-flat)
                ] if
            ]
        }
        {
            [ over branch? ] [
                over [ 2drop f ] [
                    over [ first ] bi@ g-scaling/sum
                    [ [ rest ] bi@ g-scaling/sum ] dip prefix
                ] if-empty
            ]
        }
        [ drop class-of invalid-input ]
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
: (neutral-element) ( word -- num/f )
    { { \ + [ 0.0 ] }
      { \ * [ 1.0 ] }
      { \ min [ largest-float ] }
      { \ max [ largest-float neg ] }
      [ drop f ]
    } case ;

: (reduce-tree) ( obj identity quot -- result )
    {
        { [ pick number? ] [ call( num prev -- num' ) ] }
        { [ pick sequence? ] [ [ swap ] prepose deep-reduce* ] }
        [ 2drop class-of invalid-input ]
    } cond ; inline
PRIVATE>

! &optionals: (accum nil)
GENERIC: reduce-tree ( &optionals obj fun -- result )

M: word reduce-tree ( &optionals obj sym -- result )
    rot [ swap ] [ [ (neutral-element) ] keep ] if*
    1quotation (reduce-tree) ; inline

M: callable reduce-tree ( &optionals obj quot -- result )
    swapd (reduce-tree) ; inline

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
: (scalar-filter-test)
    ( test-elt test-quot: ( elt1 elt2 -- ? ) map-quot/f: ( elt -- elt' ) -- test: ( elt -- ? ) )
    [ [ curry ] dip prepose ] [ curry ] if* ; inline

: (vector-filter-test)
    ( test-seq test-quot: ( elt1 elt2 -- ? ) map-quot/f: ( elt -- elt' ) -- test: ( elt -- ? ) )
    [ [ [ with any? ] 2curry ] dip prepose ] [ [ with any? ] 2curry ] if* ; inline
PRIVATE>

! &optionals: (test 'eq) (key nil)
GENERIC: rang-p ( &optionals seq obj -- seq' )

M: number rang-p ( &optionals seq test-elt -- seq' )
    rot [ = ] &optional-unpack2 (scalar-filter-test) filter/indices* ;

M: sequence rang-p ( &optionals seq test-seq -- seq' )
    rot [ = ] &optional-unpack2 (vector-filter-test) filter/indices* ;

! ___________
! list-filter

SYMBOLS: 'pass 'reject ;

GENERIC# list-filter 1 ( seq fun mode -- seq' )

M: word list-filter ( seq sym mode -- seq' )
    [ 1quotation ] dip list-filter ;

M: callable list-filter ( seq quot mode -- seq' )
    'reject eq? [ [ not ] compose ] when deep-filter-leaves* ;

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
