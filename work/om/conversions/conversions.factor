! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: assocs arrays combinators kernel layouts locals math math.constants
       math.functions math.order namespaces om.support present sequences ;
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

! ______
! scales

SYMBOLS: :n :s :f :q :-q :qs :f-q ;

SYMBOL: +ascii-note-C-scale+ {
    { "C" :n } { "C" :q  } { "C" :s } { "D" :-q } { "D" :n } { "D" :q  }
    { "E" :f } { "E" :-q } { "E" :n } { "E" :q  } { "F" :n } { "F" :q  }
    { "F" :s } { "G" :-q } { "G" :n } { "G" :q  } { "G" :s } { "A" :-q }
    { "A" :n } { "A" :q  } { "B" :f } { "B" :-q } { "B" :n } { "B" :q  }
} +ascii-note-C-scale+ set

SYMBOL: +ascii-note-do-scale+ {
    { "do" :n } { "do"  :q  } { "do"  :s } { "re"  :-q } { "re"  :n } { "re" :q  }
    { "mi" :f } { "mi"  :-q } { "mi"  :n } { "mi"  :q  } { "fa"  :n } { "fa" :q  }
    { "fa" :s } { "sol" :-q } { "sol" :n } { "sol" :q  } { "sol" :s } { "la" :-q }
    { "la" :n } { "la"  :q  } { "si"  :f } { "si"  :-q } { "si"  :n } { "si" :q  }
} +ascii-note-do-scale+ set

SYMBOL: +ascii-note-alterations+ {
    { :s  { "#" 100 } } { :f   { "b" -100  } }
    { :q  { "+" 50  } } { :qs  { "#+" 150  } }
    { :-q { "_" -50 } } { :f-q { "b-" -150 } }
    { :s  { "d" 100 } }
} +ascii-note-alterations+ set

SYMBOL: +ascii-note-scales+
+ascii-note-C-scale+ +ascii-note-do-scale+ [ get ] bi@ 2array
+ascii-note-scales+ set

! ______
! mc->n1

<PRIVATE
: (mc->n1-present) ( step scale oct+2 cents -- name )
    [ nth first2 +ascii-note-alterations+ get at [ first ] [ "" ] if* append ]
    [ 2 - present append ]
    [ [ 0 > "+" "" ? ] [ [ "" ] [ present ] if-zero ] bi 3append ]
    tri* ; inline

:: (mc->n1) ( midic scale -- name )
    1200 scale length / :> dmidic
    midic dmidic cl-round :> ( midic/50 cents )
    midic/50 dmidic * 1200 cl-floor :> ( oct+2 midic<1200 )
    midic<1200 dmidic / scale oct+2 cents (mc->n1-present) ; inline
PRIVATE>

: mc->n1 ( midic &optionals -- name )
    unpack1 [ +ascii-note-scales+ get first ] unless* (mc->n1) ;

SYMBOL: +ascii-intervals+ {
    "1" "2m" "2M" "3m" "3M" "4" "4A" "5" "6m" "6M" "7m" "7M"
} +ascii-intervals+ set

! ___________
! mc->n n->mc

GENERIC: mc->n ( midic -- name )

GENERIC: n->mc ( name -- midic )

! _________
! beats->ms

: beats->ms ( nbeats tempo -- duration )
    [ 1000. 60 ] dip / * * round >integer ;
