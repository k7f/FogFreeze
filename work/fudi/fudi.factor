! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: fudi.peers ;
IN: fudi

<PRIVATE
FUDI: +main-fudin+ "main.fudin" "main FUDI source"

FUDI: +main-fudout+ "main.fudout" "main FUDI sink"
PRIVATE>

: start-main-fudin ( -- ) +main-fudin+ 3000 start-fudin ;

: stop-main-fudin ( -- ) +main-fudin+ stop-fudin ;

<PRIVATE
: (main) ( -- ) start-session +main-fudin+ 3000 start-fudin ;
PRIVATE>

MAIN: (main)
