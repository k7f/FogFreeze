! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: combinators io byte-vectors kernel math math.parser sequences strings ;
IN: jp.redis.reader

<PRIVATE
TUPLE: (error-reply) expected { got string } ;
: (error-reply) ( expected got -- * )
    >string \ (error-reply) boa throw ;

: (readln) ( -- byte-vector/f )
    "\n" read-until [
        >byte-vector dup pop*
    ] [ drop f ] if ; inline

: (status-reply) ( expected byte-vector -- str/? )
    >string swap [ = ] when* ; inline

: (integer-reply) ( expected byte-vector -- num )
    nip >string string>number ; inline

: (bulk-reply) ( expected byte-vector -- byte-array/f )
    nip >string string>number dup 0 < [ drop f ] [
        read 2 read drop
    ] if ;

: (multi-reply) ( expected byte-vector -- seq/f )
    nip >string string>number dup 0 < [ drop f ] [
        iota [ (readln) rest (bulk-reply) ] map
    ] if ;

: (pull-anything) ( expected/f -- response selector )
    (readln) unclip [
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

: pull-bytes ( -- byte-array/f )
    f (pull-anything) CHAR: $ = [ drop f ] unless ;

: pull-string ( -- string/f )
    f (pull-anything) CHAR: $ = [ >string ] [ drop f ] if ;

: pull-integer ( -- int/f )
    f (pull-anything) {
        { CHAR: : [ ] }
        { CHAR: $ [ >string string>number ] }
        [ 2drop f ]
    } case ;

: pull-bulk ( -- byte-array/f ? ) f (pull-anything) CHAR: $ = ;

: pull-multi ( -- seq/f ? ) f (pull-anything) CHAR: * = ;
