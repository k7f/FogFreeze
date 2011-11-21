! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors ff.types strings ;
IN: fudi.types

! Vanilla-style FUDI transmission is done over unidirectional channels:
! fudin listens to netsends, fudout feeds netreceives.

TUPLE: (fudi) { id string } { info string } { worker ?thread } ;

TUPLE: fudin  < (fudi) ;
TUPLE: fudout < (fudi) ;
