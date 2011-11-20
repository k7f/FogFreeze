! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors concurrency.messaging debugger fry fudi.logging fudi.parser
       io io.encodings.ascii io.servers kernel lexer locals logging
       math namespaces parser sequences strings words words.symbol ;
FROM: io.sockets => <inet4> ;
IN: fudi.peers

! Vanilla-style FUDI transmission is done over unidirectional channels:
! fudin listens to netsends, fudout feeds netreceives.

SYNTAX: FUDI:
    scan-new-word [ define-symbol ]
    [ scan-object "name" set-word-prop ]
    [ scan-object "info" set-word-prop ] tri ;

: get-fudins ( fudi -- servers ) "name" word-prop get-servers-named ;

<PRIVATE
SYMBOL: (rotate-request)

: (?rotate-logs) ( -- )
    (rotate-request) get [ rotate-logs f (rotate-request) set ] when ;

ERROR: (already-running) { fudi read-only } ;
M: (already-running) error. fudi>> " is already running" bi-print ;

: (not-running!) ( fudi -- )
    dup get-fudins empty? [ drop ] [
        f (rotate-request) set
        (already-running)
    ] if ;

:: (listen) ( fudi -- )
    "OPEN connection: " fudi \ (listen) bi-NOTICE*
    [ readln dup ] [
        [ \ (listen) fudi-DEBUG* ] keep
        fudi get-global send
    ] while drop
    "CLOSE connection: " fudi \ (listen) bi-NOTICE* ;

: (fudin-handler) ( fudi quot -- quot' )
    '[ [ _ [ start-parser drop ] [ @ ] [ stop-parser ] tri ] with-fudi-logging ] ;
PRIVATE>

: start-session ( -- ) t (rotate-request) set ;

:: <fudin> ( fudi port quot -- server )
    ascii <threaded-server> fudi "name" word-prop >>name
    f port <inet4> >>insecure f >>secure f >>timeout
    fudi quot (fudin-handler) >>handler ;

: start-fudin ( fudi port -- )
    over (not-running!) (?rotate-logs)
    [ (listen) ] <fudin> start-server drop ;

:: stop-fudin ( fudi -- )
    fudi get-fudins [ "no running server for " fudi \ stop-fudin bi-WARNING ] [
        dup length 1 > [ "more than one " fudi \ stop-fudin bi-WARNING ] when
        [ stop-server ] each
    ] if-empty ;
