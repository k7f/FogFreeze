! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors ff.types kernel strings ;
IN: fudi.types

! Vanilla-style FUDI transmission is done over unidirectional channels:
! fudin listens to netsends, fudout feeds netreceives.

! Conceptually, though, Pd is the client, while ff is the server.  Pd sends
! requests and queries, ff obeys and responds -- the two should never act
! the other way.

TUPLE: (fudi) { id string } { info string } { port ?fixnum } { worker ?thread } ;

TUPLE: fudout < (fudi) ;

: <fudout> ( id info -- fudi ) f f fudout boa ;

MIXIN: ?fudout
INSTANCE: f ?fudout
INSTANCE: fudout ?fudout

TUPLE: fudin  < (fudi) { responder ?fudout } ;

: <fudin> ( id info -- fudi ) f f f fudin boa ;
