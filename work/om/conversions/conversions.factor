! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.errors addenda.sequences.deep arrays assocs combinators kernel
       layouts locals math math.constants math.functions math.order
       math.parser namespaces om.support sequences strings ;
IN: om.conversions

! __________________________________________
! 02-musicproject/functions/conversions.lisp

! ________
! approx-m

GENERIC# approx-m 2 ( cents approx &optionals -- cents' )

<PRIVATE
: (approx-m) ( cents approx -- cents' )
    [ * 100 + 200 / floor 200 * ] keep / round >integer ; inline
PRIVATE>

M: number approx-m ( cents approx &optionals -- cents' )
    over 0 <= [ 2drop ] [
        swap [ unpack1 [ - ] when* ] dip (approx-m)
    ] if ;

M: sequence approx-m ( cents approx &optionals -- cents' )
    over 0 <= [ 2drop ] [
        unpack1 [ 0 ] unless*
        [ [ swap [ - ] dip ] unless-zero (approx-m) ] 2curry map
    ] if ;

! ____________
! midicents>hz

SYMBOL: +tuning-hz+
440. +tuning-hz+ set-global
SYMBOL: +tuning-midicents+
6900 +tuning-midicents+ set-global

GENERIC: midicents>hz ( cents -- hz )

M: number midicents>hz ( cents -- hz )
    +tuning-midicents+ get-global - 1200.0 / 2.0 swap ^ +tuning-hz+ get-global * ;

M: sequence midicents>hz ( cents -- hz )
    +tuning-midicents+ get-global +tuning-hz+ get-global
    [ [ - 1200.0 / 2.0 swap ^ ] dip * ] 2curry map ;

! ____________
! hz>midicents

: +lowest-hz+ ( -- hz )
    most-negative-fixnum midicents>hz smallest-float max 256 * ; foldable

<PRIVATE
: (hz-abs) ( hz -- hz' ) abs +lowest-hz+ max ; inline
: (hz>mc-coef) ( -- coef ) 1200 2.0 log / ; foldable
: (hz>mc) ( hz -- cents )
    +tuning-hz+ get-global / (hz-abs) log (hz>mc-coef) *
    +tuning-midicents+ get-global + ; inline
PRIVATE>

GENERIC# hz>midicents 1 ( hz &optionals -- cents )

M: number hz>midicents ( hz &optionals -- cents )
    [ (hz>mc) ] [ 2 unpack2 ] bi* approx-m ;

M: sequence hz>midicents ( hz &optionals -- cents )
    2 unpack2 {
        { [ over 0 <= ] [ 2drop [ (hz>mc) ] map ] }
        { [ dup ] [ [ swap [ [ (hz>mc) ] dip - ] dip (approx-m) ] 2curry map ] }
        [ drop [ (approx-m) ] curry [ (hz>mc) ] prepose map ]
    } cond ;

! ______
! scales

SYMBOLS: :n :s :f :q :-q :qs :f-q ;

SYMBOL: +ascii-note-C-scale+
{
    { "C" :n } { "C" :q  } { "C" :s } { "D" :-q } { "D" :n } { "D" :q  }
    { "E" :f } { "E" :-q } { "E" :n } { "E" :q  } { "F" :n } { "F" :q  }
    { "F" :s } { "G" :-q } { "G" :n } { "G" :q  } { "G" :s } { "A" :-q }
    { "A" :n } { "A" :q  } { "B" :f } { "B" :-q } { "B" :n } { "B" :q  }
} +ascii-note-C-scale+ set-global

SYMBOL: +ascii-note-do-scale+
{
    { "do" :n } { "do"  :q  } { "do"  :s } { "re"  :-q } { "re"  :n } { "re" :q  }
    { "mi" :f } { "mi"  :-q } { "mi"  :n } { "mi"  :q  } { "fa"  :n } { "fa" :q  }
    { "fa" :s } { "sol" :-q } { "sol" :n } { "sol" :q  } { "sol" :s } { "la" :-q }
    { "la" :n } { "la"  :q  } { "si"  :f } { "si"  :-q } { "si"  :n } { "si" :q  }
} +ascii-note-do-scale+ set-global

SYMBOL: +ascii-note-scales+
+ascii-note-C-scale+ +ascii-note-do-scale+ [ get-global ] bi@ 2array
+ascii-note-scales+ set-global

SYMBOL: +ascii-note-alterations+
{
    { :s  { "#" 100 } } { :f   { "b" -100  } }
    { :q  { "+" 50  } } { :qs  { "#+" 150  } }
    { :-q { "_" -50 } } { :f-q { "b-" -150 } }
    { :s  { "d" 100 } }
} +ascii-note-alterations+ set-global

SYMBOL: +ascii-intervals+
{
    "1" "2m" "2M" "3m" "3M" "4" "4A" "5" "6m" "6M" "7m" "7M"
} +ascii-intervals+ set-global

! ________________
! midicents>string

<PRIVATE
: (mc>str) ( step-in-octave scale octave cents-in-step -- name )
    [ nth first2 +ascii-note-alterations+ get-global at [ first ] [ "" ] if* append ]
    [ 2 - number>string append ]
    [ [ 0 > "+" "" ? ] [ [ "" ] [ number>string ] if-zero ] bi 3append ]
    tri* ; inline

:: (midicents>string) ( cents scale -- name )
    1200 scale length / :> step-size
    cents step-size cl-round :> ( step cents-in-step )
    step step-size * 1200 cl-floor :> ( octave cents-in-octave )
    cents-in-octave step-size / scale octave cents-in-step (mc>str) ; inline
PRIVATE>

: midicents>string ( cents &optionals -- name )
    unpack1 [ +ascii-note-scales+ get-global first ] unless* (midicents>string) ;

: midicents>string* ( cents -- names )
    +ascii-note-scales+ get-global first
    [ (midicents>string) ] curry deep-map-atoms ;

! ________________
! string>midicents

<PRIVATE
:: (string-scale) ( name scale -- cents/f slice/f )
    name scale [
        dup second :n eq? [ first head? ] [ 2drop f ] if
    ] with find [
        [ 1200 scale length / * ]
        [ first length name swap tail-slice ] bi*
    ] [ drop f f ] if* ; inline

: (string-alt) ( slice -- cents+ slice' )
    dup +ascii-note-alterations+ get-global
    [ second first head? ] with find
    nip [
        second [ second ] [ first length swapd tail-slice ] bi
    ] [ 0 swap ] if* ; inline

: (string-octave-cut) ( slice -- octave-slice detune-slice )
    dup first "+-" member? 1 0 ?
    CHAR: + 2over swap index-from
    [ CHAR: - 2over swap index-from ] unless*
    nip [ cut-slice ] [ f ] if* ; inline

: (string-octave) ( slice -- cents+ )
    [ 0 ] [
        (string-octave-cut)
        [ string>number 2 + 1200 * ] [ [ string>number + ] when* ] bi*
    ] if-empty ; inline

: (string>midicents) ( name scale -- cents/f )
    (string-scale) [ (string-alt) (string-octave) + + ] when* ; inline
PRIVATE>

: string>midicents ( name &optionals -- cents/f )
    unpack1 [ +ascii-note-scales+ get-global first ] unless* (string>midicents) ;

: string>midicents* ( names -- cents )
    +ascii-note-scales+ get-global first
    [ (string>midicents) ] curry deep-map-atoms ;

! _______________
! interval>string

: interval>string ( cents -- name )
    1200 cl-floor 100 / +ascii-intervals+ get-global nth swap [
        [ 0 > [ "+" append ] when ] keep number>string append
    ] unless-zero ;

: interval>string* ( cents -- names )
    [ interval>string ] deep-map-atoms ;

! _______________
! string>interval

: string>interval ( name -- cents )
    dup CHAR: + over index [ CHAR: - over index ] unless*
    [
        cut-slice string>number [ drop invalid-input ] unless*
    ] [ 0 ] if*
    [
        >string +ascii-intervals+ get index [ invalid-input ] unless*
    ] [ 12 * ] bi* + 100 * nip ;

: string>interval* ( names -- cents )
    [ string>interval ] deep-map-atoms ;

! ________
! beats>ms

: beats>ms ( nbeats tempo -- duration )
    [ 1000. 60 ] dip / * * round >integer ;
