! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: combinators io kernel math math.parser sequences strings ;
IN: jp.redis.reader

<PRIVATE
: (status-reply) ( expected string -- string/? ) swap [ = ] when* ; inline

ERROR: (error-reply) expected { got string } ;

: (integer-reply) ( expected string -- num ) nip string>number ; inline

: (bulk-reply) ( expected string -- string/f )
    nip string>number dup 0 < [ drop f ] [
        read 2 read drop
    ] if ;

: (multi-reply) ( expected string -- seq/f )
    nip string>number dup 0 < [ drop f ] [
        iota [ readln rest (bulk-reply) ] map
    ] if ;

: (pull-anything) ( expected/f -- response selector )
    readln unclip [
        {
            { CHAR: + [ (status-reply) ] }
            { CHAR: : [ (integer-reply) ] }
            { CHAR: $ [ (bulk-reply) ] }
            { CHAR: * [ (multi-reply) ] }
            { CHAR: - [ (error-reply) ] }
        } case
    ] keep ;
PRIVATE>

: pull-anything ( -- response ) f (pull-anything) drop ;

: pull-status ( expected/f -- response/? )
    [ (pull-anything) ] [
        [ drop ] [ CHAR: + = [ drop f ] unless ] if
    ] bi ;

: pull-OK ( -- ? ) "OK" (pull-anything) drop ;

: pull-string ( -- string/f )
    f (pull-anything) CHAR: $ = [ drop f ] unless ;

: pull-integer ( -- int/f )
    f (pull-anything) {
        { CHAR: : [ ] }
        { CHAR: $ [ string>number ] }
        [ 2drop f ]
    } case ;

: pull-bulk ( -- string/f ? ) f (pull-anything) CHAR: $ = ;

: pull-multi ( -- seq/f ? ) f (pull-anything) CHAR: * = ;
