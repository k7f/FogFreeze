! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors concurrency.promises io io.encodings.utf8 io.sockets
       jp.redis.formatter jp.redis.reader kernel macros namespaces parser
       sequences ;
IN: jp.redis

: commit ( request -- ) write flush ; inline

: status\ ( request -- status/f ) commit f pull-status ;
: OK\ ( request -- ? ) commit pull-OK ;
: string\ ( request -- string/f ) commit pull-string ;
: integer\ ( request -- int/f ) commit pull-integer ;
: bulk\ ( request -- string/f ? ) commit pull-bulk ;
: multi\ ( request -- seq/f ? ) commit pull-multi ;

SYMBOL: current-redis

TUPLE: redis inet encoding password ;

<PRIVATE
CONSTANT: (default-port) 6379

ERROR: (bad-login) ;

MACRO: (request) ( req -- quot: ( redis -- req' ) )
    [
        swap password>> [
            [
                \auth OK\ [ (bad-login) ] unless
            ] curry prepose
        ] when*
    ] curry ;
PRIVATE>

: <local-redis> ( -- redis )
    "127.0.0.1" (default-port) <inet>
    utf8 f redis boa ;

! __________________
! blocking interface

: with-redis ( redis quot -- )
    [ [ inet>> ] [ encoding>> ] [ ] tri ]
    [ (request) with-client ] bi* ; inline

: with-current-redis ( quot -- )
    current-redis get-global swap with-redis ; inline

SYNTAX: [R
    parse-quotation suffix! \ with-current-redis suffix! ;

! FIXME
! : detach ( request -- promise )
! : promise-with-redis ( redis quot -- promise )
! : promise-with-current-redis ( quot -- promise )
! SYNTAX:

<local-redis> current-redis set-global
