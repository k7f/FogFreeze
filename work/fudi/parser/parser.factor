! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors combinators concurrency.messaging fudi.logging fudi.state
       kernel logging math.parser namespaces sequences splitting threads ;
IN: fudi.parser

<PRIVATE
: (unterminated-message) ( message -- ) \ (unterminated-message) fudi-ERROR ;

! FIXME validation
: (parse-message) ( message -- )
    dup last CHAR: ; = [
        dup \ (parse-message) fudi-DEBUG
        but-last-slice " " split1-slice swap {
            {
                [ dup "array" 5 head-slice = ] [
                    drop " " split1 " " split [ string>number ] map update-remotes
                ]
            } {
                [ dup "value" 5 head-slice = ] [
                    drop " " split1 string>number update-remotes
                ]
            }
            [ 2drop ]
        } cond
    ] [ (unterminated-message) ] if ;

: (parser-loop) ( fudi -- )
    [
        [ receive dup ] [ (parse-message) ] while drop
        f swap set-global
    ] with-fudi-logging ;
PRIVATE>

! FIXME do not spawn a new parser for every connection -- use only one, refcounted

: start-parser ( fudi -- parser )
    [ [ (parser-loop) ] curry "FUDI parser" spawn dup ] keep set-global ;

: stop-parser ( fudi -- )
    dup get-global [ f swap send drop ] [
        "no running parser for " swap \ stop-parser bi-WARNING
    ] if* ;
