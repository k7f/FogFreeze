! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors kernel math strings threads ;
IN: fudi.types

! Vanilla-style FUDI transmission is done over unidirectional channels:
! fudin listens to netsends, fudout feeds netreceives.

! Conceptually, though, Pd is the client, while ff is the server.  Pd sends
! requests and queries, ff obeys and responds -- the two should never act
! the other way.

TUPLE: (fudi) { id string } { info string } { port maybe: fixnum } { worker maybe: thread } ;

TUPLE: fudout < (fudi) ;

: <fudout> ( id info -- fudi ) f f fudout boa ;

TUPLE: fudin  < (fudi) { responder maybe: fudout } ;

: <fudin> ( id info -- fudi ) f f f fudin boa ;
