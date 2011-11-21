! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors calendar concurrency.messaging continuations debugger fry
       fudi.logging fudi.parser fudi.state io io.encodings.ascii io.servers
       kernel lexer locals logging math namespaces parser present prettyprint
       sequences strings threads words words.symbol ;
FROM: io.sockets => <inet4> with-client ;
IN: fudi.peers

! Vanilla-style FUDI transmission is done over unidirectional channels:
! fudin listens to netsends, fudout feeds netreceives.

! A symbol created with the FUDI: syntax is then to be bound to the
! worker thread of a fudi: a fudin's parser thread or a fudout's
! feeder thread.  The binding is expected to last precisely for the
! thread's lifetime, i.e validity should be guaranteed.
SYNTAX: FUDI:
    scan-new-word [ define-symbol ]
    [ scan-object "name" set-word-prop ]
    [ scan-object "info" set-word-prop ] tri ;

: get-fudins  ( fudi -- servers ) "name" word-prop get-servers-named ;

<PRIVATE
SYMBOL: (rotate-request)

: (?rotate-logs) ( -- )
    (rotate-request) get [ rotate-logs f (rotate-request) set ] when ;

ERROR: (already-running) { fudi read-only } ;
M: (already-running) error. fudi>> " is already running" bi-print ;

ERROR: (not-running) { fudi read-only } ;
M: (not-running) error. fudi>> "no running " swap bi-print ;

: (no-fudin!) ( fudi -- )
    dup get-fudins empty? [ drop ] [
        f (rotate-request) set
        (already-running)
    ] if ;

: (running-fudin!) ( fudi -- )
    dup get-fudins empty? [ (not-running) ] [ drop ] if ;

: (no-fudout!) ( fudi -- )
    dup get-global [ (already-running) ] [ drop ] if ;

: (running-fudout!) ( fudi -- )
    dup get-global [ drop ] [ (not-running) ] if ;

: (feeder-thread-name) ( feeder -- string )
    [ name>> ] [ insecure>> present ] bi " feeder on " glue ;

:: (listen) ( fudi -- )
    "OPEN connection: " fudi \ (listen) bi-NOTICE*
    [ readln dup ] [
        [ \ (listen) fudi-DEBUG* ] keep
        fudi get-global send
    ] while drop
    "CLOSE connection: " fudi \ (listen) bi-NOTICE* ;

:: (feed) ( fudi -- )
    "OPEN connection: " fudi \ (feed) bi-NOTICE*
    [ receive dup ] [
        [ \ (feed) fudi-DEBUG* ] keep
        print flush
    ] while drop
    "CLOSE connection: " fudi \ (feed) bi-NOTICE* ;

! Returns a quotation which is spawned as a listener thread.  There
! may be several listener threads for a single fudin.  The parser
! thread is spawned by the first instance of a listener thread.
: (fudin-handler) ( fudi quot -- quot' )
    '[
        [
            _ [ start-parser drop ] [ @ ] [ stop-parser ] tri
        ] with-fudi-logging
    ] ;

! Returns a quotation which is spawned as a feeder thread.  There is
! never more than one feeder thread for a single fudout.
:: (fudout-handler) ( feeder fudi quot -- quot' )
    [
        self fudi set-global
        feeder [ insecure>> ] [ encoding>> ] bi [
            fudi quot curry with-fudi-logging
        ] [ with-client ] [ error. 3drop ] recover
        f fudi set-global
    ] ;
PRIVATE>

: start-session ( -- ) t (rotate-request) set ;

:: <fudin> ( fudi port quot -- server )
    ascii <threaded-server> fudi "name" word-prop >>name
    f port <inet4> >>insecure f >>secure f >>timeout
    fudi quot (fudin-handler) >>handler ;

: start-fudin ( fudi port -- )
    over (no-fudin!) (?rotate-logs)
    [ (listen) ] <fudin> start-server drop ;

:: stop-fudin ( fudi -- )
    fudi get-fudins [ "no running server for " fudi \ stop-fudin bi-WARNING ] [
        dup length 1 > [ "more than one " fudi \ stop-fudin bi-WARNING ] when
        [ stop-server ] each
    ] if-empty ;

TUPLE: threaded-feeder < identity-tuple
    name log-level insecure timeout encoding handler stopped ;

: <threaded-feeder> ( encoding -- feeder )
    threaded-feeder new "anonymous" >>name DEBUG >>log-level
    1 minutes >>timeout swap >>encoding
    [ "No handler quotation" throw ] >>handler ;

: start-threaded-feeder ( feeder -- thread )
    dup name>> [
        [ handler>> ]
        [ (feeder-thread-name) ] bi spawn
    ] with-logging ;

:: <fudout> ( fudi port quot -- fudout )
    ascii <threaded-feeder> fudi "name" word-prop >>name
    f port <inet4> >>insecure f >>timeout
    dup fudi quot (fudout-handler) >>handler ;

: start-fudout ( fudi port -- )
    over (no-fudout!) [ (feed) ] <fudout> start-threaded-feeder drop ;

:: stop-fudout ( fudi -- )
    fudi get-global [ f swap send ] [
        "no running feeder for " fudi \ stop-fudout bi-WARNING
    ] if* ;
