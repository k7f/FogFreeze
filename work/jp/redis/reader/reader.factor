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

: (status-reply) ( expected/f byte-vector -- string/? )
    >string swap [ = ] when* ; inline

: (integer-reply) ( expected/f byte-vector -- num )
    nip >string string>number ; inline

: (bulk-reply) ( expected/f byte-vector -- byte-array/f )
    nip >string string>number dup 0 < [ drop f ] [
        read 2 read drop
    ] if ;

: (multi-reply) ( expected/f byte-vector -- seq/f )
    nip >string string>number dup 0 < [ drop f ] [
        iota [ (readln) rest (bulk-reply) ] map
    ] if ;

: (mock-reply) ( expected/f byte-vector -- expected/f ) drop ;

: (pull-anything) ( expected/f -- response selector )
    (readln) unclip [
        {
            { CHAR: + [ (status-reply) ] }
            { CHAR: : [ (integer-reply) ] }
            { CHAR: $ [ (bulk-reply) ] }
            { CHAR: * [ (multi-reply) ] }
            { CHAR: - [ (error-reply) ] }
            { CHAR: # [ (mock-reply) ] }
        } case
    ] keep ;
PRIVATE>

: pull-anything ( -- response ) f (pull-anything) drop ;

! FIXME redundant comparison if status
: pull-? ( expected -- expected/f )
    dup (pull-anything) drop [ = ] keep f ? ;

: pull-status ( expected/f -- response/? )
    [ (pull-anything) ] [
        [ drop ] [ CHAR: + = [ drop f ] unless ] if
    ] bi ;

: pull-OK ( -- ? ) "OK" (pull-anything) drop ;

: pull-bytes ( -- byte-array/f )
    B{ } clone (pull-anything) dup CHAR: $ = [ drop ] [
        CHAR: # = [ drop f ] unless
    ] if ;

: pull-string ( -- string/f )
    B{ } clone (pull-anything) dup CHAR: $ = [ drop >string ] [
        CHAR: # = [ >string ] [ drop f ] if
    ] if ;

: pull-integer ( -- int/f )
    f (pull-anything) {
        { CHAR: : [ ] }
        { CHAR: $ [ >string string>number ] }
        [ 2drop f ]
    } case ;

: pull-bulk ( -- byte-array/f ? ) f (pull-anything) CHAR: $ = ;

: pull-multi ( -- seq/f ? ) f (pull-anything) CHAR: * = ;
