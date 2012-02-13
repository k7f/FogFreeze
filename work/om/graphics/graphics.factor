! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors combinators kernel locals math math.functions math.order
       slots ;
IN: om.graphics

! _______________________
! api/om-LW/graphics.lisp

! ________
! om-point

TUPLE: om-point { x number initial: 0 } { y number initial: 0 } ;

: <om-point> ( x y -- pt ) om-point boa ;

ALIAS: om-make-point <om-point>

: om-add-points ( pt1 pt2 -- newpt )
    [ [ x>> ] bi@ + ] [ [ y>> ] bi@ + ] 2bi <om-point> ;

<PRIVATE
: (om-subtract-points) ( pt1 pt2 -- x y )
    [ [ x>> ] bi@ - ] [ [ y>> ] bi@ - ] 2bi ; inline
PRIVATE>

: om-subtract-points ( pt1 pt2 -- newpt )
    (om-subtract-points) <om-point> ;

: om-point-* ( pt coef -- newpt )
    [ [ x>> ] dip * ] [ [ y>> ] dip * ] 2bi <om-point> ;

: dot-prod-2D ( pt1 pt2 -- result )
    [ [ x>> ] bi@ * ] [ [ y>> ] bi@ * ] 2bi + ;

<PRIVATE
: (coords) ( pt -- x y )
    [ x>> ] [ y>> ] bi ; inline

: (norm-2D) ( x y -- result )
    [ dup * ] bi@ + sqrt ; inline
PRIVATE>

: norm-2D ( pt -- result )
    (coords) (norm-2D) ;

: dist2D ( pt1 pt2 -- result )
    (om-subtract-points) (norm-2D) ;

<PRIVATE
: (angle/vec) ( pt lpt1 lpt2 -- cos1 vec )
    over [ om-subtract-points ] 2bi@ [ dot-prod-2D ] keep ;
PRIVATE>

:: dist-to-line ( pt lpt1 lpt2 -- result )
    pt lpt1 lpt2 (angle/vec) :> ( cos1 vec )
    cos1 0 <= [ pt lpt1 dist2D ] [
        vec dup dot-prod-2D :> cos2
        cos2 cos1 <= [ pt lpt2 dist2D ] [
            cos1 cos2 / vec [ x>> * ] [ y>> * ] 2bi  ! FIXME why the rounding in OM?
            [ lpt1 (coords) ] 2dip swapd [ + ] 2bi@
            [ pt (coords) ] 2dip swapd [ - ] 2bi@ (norm-2D)
        ] if
    ] if ;

: om-point-in-line? ( pt lpt1 lpt2 delta -- ? )
    [ dist-to-line ] dip <= ;

! _______
! om-rect

TUPLE: om-rect
    { rx number initial: 0 }
    { ry number initial: 0 }
    { rw number initial: 0 }
    { rh number initial: 0 } ;

: <om-rect> ( left top right bottom -- rect )
    [ pick - ] bi@ om-rect boa ;

ALIAS: om-make-rect <om-rect>

: om-pts-to-rect ( pt1 pt2 -- rect )
    [ [ [ x>> ] bi@ min ] [ [ y>> ] bi@ min ] 2bi ]
    [ [ [ x>> ] bi@ max ] [ [ y>> ] bi@ max ] 2bi ] 2bi <om-rect> ;

<< "right" "bottom" [ define-reader-generic ] bi@ >>

M: om-rect right>>  ( rect -- num ) [ rx>> ] [ rw>> ] bi + ; inline
M: om-rect bottom>> ( rect -- num ) [ ry>> ] [ rh>> ] bi + ; inline

: om-rect-top    ( rect -- num ) ry>> ; inline
: om-rect-bottom ( rect -- num ) bottom>> ; inline
: om-rect-left   ( rect -- num ) rx>> ; inline
: om-rect-right  ( rect -- num ) right>> ; inline
: om-rect-w      ( rect -- num ) rw>> ; inline
: om-rect-h      ( rect -- num ) rh>> ; inline

: om-rect-topleft ( rect -- pt )
    [ rx>> ] [ ry>> ] bi <om-point> ;

: om-rect-bottomright ( rect -- pt )
    [ right>> ] [ bottom>> ] bi <om-point> ;

<PRIVATE
: (om-sect-rect) ( rect1 rect2 -- left right top bottom )
    [ [ [ rx>> ] bi@ max ] [ [ right>>  ] bi@ min ] 2bi ]
    [ [ [ ry>> ] bi@ max ] [ [ bottom>> ] bi@ min ] 2bi ] 2bi ; inline
PRIVATE>

: om-sect-rect ( rect1 rect2 -- newrect/f )
    (om-sect-rect) [ 2dup <= ] 2bi@ [ rot ] dip and
    [ swapd <om-rect> ] [ 2drop 2drop f ] if ;

: om-point-in-rect? ( pt rect -- ? )
    {
        { [ 2dup [ x>> ] [ rx>>     ] bi* < ] [ f ] }
        { [ 2dup [ x>> ] [ right>>  ] bi* > ] [ f ] }
        { [ 2dup [ y>> ] [ ry>>     ] bi* < ] [ f ] }
        { [ 2dup [ y>> ] [ bottom>> ] bi* > ] [ f ] }
        [ t ]
    } cond 2nip ;
