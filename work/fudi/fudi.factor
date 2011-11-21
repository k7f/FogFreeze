! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: fudi.peers ;
IN: fudi

<PRIVATE
FUDI: +main-fudin+ "main.fudin" "main FUDI source"

FUDI: +main-fudout+ "main.fudout" "main FUDI sink"
PRIVATE>

: start-main-fudin  ( -- ) +main-fudin+  3000 start-fudin ;
: start-main-fudout ( -- ) +main-fudout+ 3001 start-fudout ;

: stop-main-fudin  ( -- ) +main-fudin+  stop-fudin ;
: stop-main-fudout ( -- ) +main-fudout+ stop-fudout ;

<PRIVATE
: (main) ( -- ) start-session +main-fudin+ 3000 start-fudin ;
PRIVATE>

MAIN: (main)
