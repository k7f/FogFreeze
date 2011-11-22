! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors combinators concurrency.messaging fudi.logging fudi.state
       fudi.types kernel logging math math.parser namespaces sequences
       splitting strings threads ;
IN: fudi.parser

<PRIVATE
: (unterminated-message) ( message -- ) \ (unterminated-message) fudi-ERROR ;

! FIXME validation
: (parse-message) ( fudi message -- )
    dup last CHAR: ; = [
        ! dup \ (parse-message) fudi-DEBUG
        but-last-slice " " split1-slice swap {
            {
                [ dup "array" 5 head-slice = ] [
                    drop " " split1 " " split [ string>number ] map set-remote drop
                ]
            } {
                [ dup "float" 5 head-slice = ] [
                    drop " " split1 string>number set-remote drop
                ]
            } {
                [ dup "tap-on" 6 head-slice = ] [
                    drop " " split1 drop >string swap publish
                ]
            } {
                [ dup "tap-off" 7 head-slice = ] [
                    drop " " split1 drop >string f publish drop
                ]
            }
            [ 3drop ]
        } cond
    ] [ (unterminated-message) drop ] if ;

: (parser-loop) ( fudi -- )
    [ receive dup ] [ (parse-message) ] with while drop ;

: (parser-handler) ( fudi quot -- quot' )
    dupd curry [ with-fudi-logging f swap worker<< ] 2curry ;
PRIVATE>

! FIXME do not spawn a new parser for every connection -- use only one, refcounted

: start-parser ( fudi -- parser )
    [ [ (parser-loop) ] (parser-handler) "FUDI parser" spawn dup ] keep worker<< ;

: stop-parser ( fudi -- )
    dup worker>> [ f swap send drop ] [
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
    [ (unparse-local) ] dip worker>>
    2dup and [ send ] [ 2drop ] if ;
PRIVATE>

M: fudout publish ( name fudi -- ) [ (tap-out) ] curry publish ;
