! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors calendar concurrency.messaging continuations debugger fry
       fudi.logging fudi.parser fudi.parser.rules fudi.state fudi.types io
       io.encodings.ascii io.servers kernel lexer locals logging math
       namespaces parser present prettyprint sequences splitting strings
       threads words.symbol ;
FROM: io.sockets => <inet4> with-client ;
IN: fudi.peers

! A symbol created with the FUDIN: syntax is bound, permanently, to a fudin
! tuple.  The worker field points to a fudin's parser thread.
! The validity of that field should be guaranteed, i.e. its non-nil value is
! expected to last precisely for the thread's lifetime.
SYNTAX: FUDIN:
    scan-new-word [
        define-symbol scan-object scan-object <fudin>
    ] keep set-global ;

! A symbol created with the FUDOUT: syntax is bound, permanently, to a fudout
! tuple.  The worker field points to a fudout's feeder thread.
! The validity of that field should be guaranteed, i.e. its non-nil value is
! expected to last precisely for the thread's lifetime.
SYNTAX: FUDOUT:
    scan-new-word [
        define-symbol scan-object scan-object <fudout>
    ] keep set-global ;

: get-fudins  ( fudi -- servers ) id>> get-servers-named ;

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
    dup worker>> [ (already-running) ] [ drop ] if ;

: (running-fudout!) ( fudi -- )
    dup worker>> [ drop ] [ (not-running) ] if ;

: (feeder-thread-name) ( feeder -- string )
    [ name>> ] [ insecure>> present ] bi " feeder on " glue ;

:: (listen) ( fudi -- )
    "OPEN connection: " fudi \ (listen) bi-NOTICE*
    [ readln dup ] [
        [ \ (listen) fudi-DEBUG* ] keep
        fudi worker>> send
    ] while drop
    "CLOSE connection: " fudi \ (listen) bi-NOTICE* ;

:: (feed) ( fudi -- )
    "OPEN connection: " fudi \ (feed) bi-NOTICE*
    [ receive dup ] [
        [ \ (feed) fudi-DEBUG* ] keep
        [ print flush ] [ 2drop ] recover  ! FIXME terminate the thread on error
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
        self fudi worker<<
        feeder [ insecure>> ] [ encoding>> ] bi [
            fudi quot curry with-fudi-logging
        ] [ with-client ] [ error. 3drop ] recover
        f fudi worker<<
    ] ;
PRIVATE>

: start-session ( -- ) t (rotate-request) set ;

:: <fudi-server> ( fudi port quot -- server )
    ascii <threaded-server> fudi id>> >>name
    f port <inet4> >>insecure f >>secure f >>timeout
    fudi quot (fudin-handler) >>handler
    port fudi port<< ;

: start-fudin* ( fudi port -- )
    over (no-fudin!) (?rotate-logs) [ (listen) ] <fudi-server> start-server drop ;

: stop-fudin* ( fudi -- )
    dup get-fudins [
        "no running server for " swap \ stop-fudin* bi-WARNING
    ] [
        dup length 1 > [
            "more than one " rot \ stop-fudin* bi-WARNING
        ] [ nip ] if
        [ stop-server ] each
    ] if-empty ;

: start-fudin ( fudi-word port -- ) [ get-global ] dip start-fudin* ;

: stop-fudin ( fudi-word -- ) get-global stop-fudin* ;

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

:: <fudi-feeder> ( fudi port quot -- feeder )
    ascii <threaded-feeder> fudi id>> >>name
    f port <inet4> >>insecure f >>timeout
    dup fudi quot (fudout-handler) >>handler
    port fudi port<< ;

: start-fudout* ( fudi port -- )
    over (no-fudout!) [ (feed) ] <fudi-feeder> start-threaded-feeder drop ;

: stop-fudout* ( fudi -- )
    dup worker>> [ f swap send drop ] [
        "no running feeder for " swap \ stop-fudout* bi-WARNING
    ] if* ;

: start-fudout ( fudi-word port -- ) [ get-global ] dip start-fudout* ;

: stop-fudout ( fudi-word -- ) get-global stop-fudout* ;

: new-responder ( fudi -- fudi' )
    [ id>> ".responder" append ] [ info>> "'s responder" append ] bi <fudout> ;

: get-responder ( fudi -- fudi' )
    dup responder>> [
        "invoked by " over \ get-responder bi-NOTICE
        [ ] [ port>> 1 + ] [ new-responder ] tri
        [ swap start-fudout* ] [ >>responder ] [ ] tri
    ] unless* nip ;

: respond ( cell name fudi -- )
    get-responder [ [ value>> ] [ f ] if* ] 2dip feed-out* ;

FUDI-RULE: get => [
    " " split1 [ >string [ get-local ] keep ] dip [ nip >string ] when*
] dip respond ;

FUDI-RULE: recall => [
    " " split1 [ >string [ get-remote ] keep ] dip [ nip >string ] when*
] dip respond ;

M: fudin publish ( name fudi -- ) get-responder publish ;
