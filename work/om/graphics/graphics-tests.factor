! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: kernel om.graphics tools.test ;
IN: om.graphics.tests

[ T{ om-point f 1 2 } ] [
    1 2 <om-point>
] unit-test

[ T{ om-point f 2 4 } ] [
    1 2 <om-point> dup om-add-points
] unit-test

[ T{ om-point f 0 0 } ] [
    1 2 <om-point> dup om-subtract-points
] unit-test

[ T{ om-point f 3 6 } ] [
    1 2 <om-point> 3 om-point-*
] unit-test

[ 15 ] [
    1 2 <om-point> dup 3 om-point-* dot-prod-2D
] unit-test

[ 1.0 ] [
    1 0 <om-point> norm-2D
] unit-test

[ 4.0 ] [
    0 2 <om-point> dup 3 om-point-* dist2D
] unit-test

[ 0.0 ] [
    1 1 0 0 2 2 [ <om-point> ] 2tri@ dist-to-line
] unit-test

[ f ] [
    2 1 0 0 1 2 [ <om-point> ] 2tri@ 1.3 om-point-in-line?
] unit-test

[ t ] [
    2 1 0 0 1 2 [ <om-point> ] 2tri@ 1.4 om-point-in-line?
] unit-test

[ T{ om-rect f 1 2 2 2 } ] [
    1 2 3 4 <om-rect>
] unit-test

[ T{ om-rect f 1 2 2 4 } ] [
    1 2 <om-point> dup 3 om-point-* om-pts-to-rect
] unit-test

[ T{ om-rect f 1 2 1 1 } ] [
    0 1 2 3 <om-rect> 1 2 3 4 <om-rect> om-sect-rect
] unit-test

[ f ] [
    0 5 <om-point> 1 2 3 4 <om-rect> om-point-in-rect?
] unit-test

[ t ] [
    2 3 <om-point> 1 2 3 4 <om-rect> om-point-in-rect?
] unit-test
