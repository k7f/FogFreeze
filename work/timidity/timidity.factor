! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors combinators destructors io io.encodings.utf8 io.launcher
       io.pipes io.ports io.streams.duplex kernel math.parser namespaces
       prettyprint sequences ;
IN: timidity

<PRIVATE
SYMBOLS:
    (verbosity)
    (tempo-adjust)
    (current-path)
    (current-player)
    (player-io-stream)
    (player-error-port) ;

: (-ioption) ( -- string )
    (verbosity) get [ "-id" " " surround ] [ "-idq " ] if* ;

: (-Toption) ( -- string/f )
    (tempo-adjust) get [ number>string "-T " " " surround ] [ f ] if* ;

: (path>command) ( path -- command )
    [ "timidity " (-ioption) append (-Toption) [ append ] when* ] dip append ;
PRIVATE>

: <player-stream*> ( path -- error-port stream process )
    (path>command) utf8 [
        [
            (pipe) (pipe) (pipe) {
                [ [ |dispose drop ] tri@ ]
                [
                    [ rot ] dip swap >process
                    [ swap in>> or ] change-stdin
                    [ swap out>> or ] change-stdout
                    [ swap out>> or ] change-stderr
                    run-detached
                ]
                [ [ out>> dispose ] [ out>> dispose ] [ in>> dispose ] tri* ]
                [ [ in>> <input-port> ] [ in>> <input-port> ] [ out>> <output-port> ] tri* ]
            } 3cleave
        ] dip <encoder-duplex> rot
    ] with-destructors ;

: with-verbosity ( string quot -- ) [ (verbosity) ] dip with-variable ; inline

: with-tempo ( percentage quot -- ) [ (tempo-adjust) ] dip with-variable ; inline

: play! ( path -- )
    dup (current-path) set-global (path>command) utf8 [
        [ readln dup ] [ . ] while drop
    ] with-process-reader ;

: play ( path -- )
    dup (current-path) set-global <player-stream*> [
        [ (player-error-port) set-global ] dip
        (player-io-stream) set-global
    ] dip (current-player) set-global ;

: replay ( -- )
    (current-path) get-global [ play ] when* ;

: stop ( -- )
    (current-player) get-global [
        kill-process f (current-player) set  ! keep (player-io-stream) for reading
    ] when* ;

: player-readln ( -- str/f )
    (player-io-stream) get-global [
        dup in>> stream>> disposed>> [ drop f ] [ stream-readln ] if
    ] [ f ] if* ;

: player-lines ( -- seq )
    (player-io-stream) get-global [
        dup in>> stream>> disposed>> [ drop f ] [ stream-lines ] if
    ] [ f ] if* ;
