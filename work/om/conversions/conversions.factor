! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: combinators kernel layouts math math.constants math.functions
       math.order namespaces om.support sequences ;
IN: om.conversions

! __________________________________________
! 02-musicproject/functions/conversions.lisp

! ________
! approx-m

GENERIC# approx-m 2 ( midic approx &optionals -- midic' )

<PRIVATE
: (approx-m) ( midic approx -- midic' )
    [ * 100 + 200 / floor 200 * ] keep / round >integer ; inline
PRIVATE>

M: number approx-m ( midic approx &optionals -- midic' )
    over 0 <= [ 2drop ] [
        swap [ unpack1 [ - ] when* ] dip (approx-m)
    ] if ;

M: sequence approx-m ( midics approx &optionals -- midics' )
    over 0 <= [ 2drop ] [
        unpack1 [ 0 ] unless*
        [ [ swap [ - ] dip ] unless-zero (approx-m) ] 2curry map
    ] if ;

! ___________
! mc->f f->mc

SYMBOL: +tuning-freq+ 440.0 +tuning-freq+ set
SYMBOL: +tuning-midic+ 6900 +tuning-midic+ set

GENERIC: mc->f ( midic -- freq )

M: number mc->f ( midic -- freq )
    +tuning-midic+ get - 1200.0 / 2.0 swap ^ +tuning-freq+ get * ;

M: sequence mc->f ( midics -- freqs )
    +tuning-midic+ get +tuning-freq+ get
    [ [ - 1200.0 / 2.0 swap ^ ] dip * ] 2curry map ;

: +lowest-freq+ ( -- freq )
    most-negative-fixnum mc->f smallest-float max 256 * ; foldable

<PRIVATE
: (abs-f1) ( freq -- freq' ) abs +lowest-freq+ max ; inline
: (f->mf-coef) ( -- coef ) 1200 2.0 log / ; foldable
: (f->mf) ( freq -- midic )
    +tuning-freq+ get / (abs-f1) log (f->mf-coef) * +tuning-midic+ get + ; inline
PRIVATE>

GENERIC# f->mc 1 ( freq &optionals -- midic )

M: number f->mc ( freq &optionals -- midic )
    [ (f->mf) ] [ 2 unpack2 ] bi* approx-m ;

M: sequence f->mc ( freqs &optionals -- midics )
    2 unpack2 {
        { [ over 0 <= ] [ 2drop [ (f->mf) ] map ] }
        { [ dup ] [ [ swap [ [ (f->mf) ] dip - ] dip (approx-m) ] 2curry map ] }
        [ drop [ (approx-m) ] curry [ (f->mf) ] prepose map ]
    } cond ;

! _________
! beats->ms

: beats->ms ( nbeats tempo -- duration )
    [ 1000. 60 ] dip / * * round >integer ;
