! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors combinators concurrency.messaging fudi.logging fudi.state
       kernel logging math math.parser namespaces sequences splitting threads
       words ;
IN: fudi.parser

<PRIVATE
: (unterminated-message) ( message -- ) \ (unterminated-message) fudi-ERROR ;

! FIXME validation
: (parse-message) ( message -- )
    dup last CHAR: ; = [
        ! dup \ (parse-message) fudi-DEBUG
        but-last-slice " " split1-slice swap {
            {
                [ dup "array" 5 head-slice = ] [
                    drop " " split1 " " split [ string>number ] map set-remote
                ]
            } {
                [ dup "value" 5 head-slice = ] [
                    drop " " split1 string>number set-remote
                ]
            }
            [ 2drop ]
        } cond
    ] [ (unterminated-message) ] if ;

: (parser-loop) ( fudi -- )
    [ receive dup ] [ (parse-message) ] while 2drop ;

: (parser-handler) ( fudi quot -- quot' )
    dupd curry [ with-fudi-logging f swap set-global ] 2curry ;
PRIVATE>

! FIXME do not spawn a new parser for every connection -- use only one, refcounted

: start-parser ( fudi -- parser )
    [ [ (parser-loop) ] (parser-handler) "FUDI parser" spawn dup ] keep set-global ;

: stop-parser ( fudi -- )
    dup get-global [ f swap send drop ] [
        "no running parser for " swap \ stop-parser bi-WARNING
    ] if* ;

<PRIVATE
: (unparse-local) ( value name -- message/f )
    over real? [ swap number>string " " glue " ;" append ] [
        over sequence? [
            swap [
                [ number>string ] [ " " glue ] map-reduce " " glue
            ] unless-empty
            " ;" append
        ] [ 2drop f ] if
    ] if ;

: (tap-out) ( value name fudi -- )
    [ (unparse-local) ] dip get-global
    2dup and [ send ] [ 2drop ] if ;
PRIVATE>

M: word publish ( name fudi -- ) [ (tap-out) ] curry publish ;
