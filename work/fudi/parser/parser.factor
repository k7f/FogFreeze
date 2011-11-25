! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors arrays combinators concurrency.messaging fry fudi.logging
       fudi.parser.rules fudi.state fudi.types kernel logging macros math
       math.parser namespaces prettyprint sequences splitting strings threads ;
IN: fudi.parser

! FIXME validation

<PRIVATE
: (unterminated-message) ( message -- ) \ (unterminated-message) fudi-ERROR ;

! ______________
! Push interface
! -- requests for writing to a remote cell.

! clear <v>
! array <v> <list-of-numbers>
! float <v> <number>
! track <v>
! event <v> <time-stamp> <number>
! clone <vto> <vfrom>

FUDI-RULE: clear => drop " " split1 drop >string f set-remote ;

FUDI-RULE: array => drop " " split1 " " split [ string>number ] map set-remote ;

FUDI-RULE: float => drop " " split1 string>number set-remote ;

FUDI-RULE: track => drop " " split1 drop >string { } set-remote ;

FUDI-RULE: event => drop " " split1 " " split1 [ string>number ] bi@ push-remote-event ;

FUDI-RULE: clone => drop " " split1 clone-remote ;

! ______________
! Pull interface
! -- requests for reading from a cell (remote or local).

! get <v> (defined in peers)
! recall <v> (defined in peers)
! tap-on <v>
! tap-off <v>

FUDI-RULE: tap-on => [ " " split1 drop >string ] dip publish ;

FUDI-RULE: tap-off => drop " " split1 drop >string f publish ;

<PRIVATE
SYMBOLS: (log-rules?) (log-messages?) ;

! Expects a semicolon-terminated message consisting of a selector, a name
! of a cell and optional arguments.  The namespace used for cell's look-up
! is rule-dependent.
MACRO: (parse-message) ( rules -- )  ! ( fudi message -- )
    dup '[
        (log-rules?) get-global [ _ unparse \ (parse-message) fudi-DEBUG ] when
        dup last CHAR: ; = [
            (log-messages?) get-global [ dup \ (parse-message) fudi-DEBUG ] when
            but-last-slice " " split1-slice swap
            _ cond
        ] [ (unterminated-message) drop ] if
    ] ;

: (parser-loop) ( fudi rules -- )
    [ receive dup ] swap [ (parse-message) ] curry with while drop ; inline

: (parser-handler) ( fudi quot -- quot' )
    dupd curry [ with-fudi-logging f swap worker<< ] 2curry ;
PRIVATE>

: start-logging-rules ( -- ) t (log-rules?) set-global ;
: stop-logging-rules ( -- ) f (log-rules?) set-global ;
: start-logging-messages ( -- ) t (log-messages?) set-global ;
: stop-logging-messages ( -- ) f (log-messages?) set-global ;

! FIXME do not spawn a new parser for every connection -- use only one, refcounted

: start-parser ( fudi -- parser )
    [
        [ parse-rules (parser-loop) ]
        (parser-handler) "FUDI parser" spawn dup
    ] keep worker<< ;

: stop-parser ( fudi -- )
    dup worker>> [ f swap send drop ] [
        "no running parser for " swap \ stop-parser bi-WARNING
    ] if* ;

<PRIVATE
: (fudi-unparse-unsafe) ( value name -- message/f )
    over real? [ swap number>string " " glue " ;" append ] [
        over sequence? [
            swap [
                [ number>string ] [ " " glue ] map-reduce " " glue
            ] unless-empty
            " ;" append
        ] [ 2drop f ] if
    ] if ;

: (fudi-unparse) ( value name -- message/f )
    over [ (fudi-unparse-unsafe) ] [ 2drop f ] if ;

: (fudi-unparse*) ( value name -- message/f )
    over [ (fudi-unparse-unsafe) ] [ nip " bang ;" append ] if ;

: (log-feed-out) ( value name fudi word -- )
    [
        dup string? [ drop "?" ] unless swap unparse " <- " glue " from " append
    ] 2dip bi-DEBUG ;
PRIVATE>

! The request is ignored, silently, unless there is both, anything
! valid to send (a number or a sequence of numbers) and anything to
! send to (a feeder thread is running).
: feed-out ( value name fudi -- )
    [ \ feed-out (log-feed-out) ] 3keep
    [ (fudi-unparse) ] dip worker>>
    2dup and [ send ] [ 2drop ] if ;

! The request is ignored, silently, unless there is both, anything
! valid to send (the f, a number, or a sequence of numbers) and
! anything to send to (a feeder thread is running).
: feed-out* ( value name fudi -- )
    [ \ feed-out* (log-feed-out) ] 3keep
    [ (fudi-unparse*) ] dip worker>>
    2dup and [ send ] [ 2drop ] if ;

M: fudout publish ( name fudi -- ) [ feed-out ] curry publish ;
