! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors concurrency.promises io io.encodings.binary io.sockets
       jp.redis.formatter jp.redis.mocker jp.redis.reader kernel namespaces
       sequences strings threads ;
IN: jp.redis

! use the 2.x protocol by default, 1.x on demand
<< use-new-protocol >>

: commit ( request -- ) write flush ; inline

: ?\ ( request expected --  expected/f )
    [ commit ] [ pull-? ] bi* ;

: status\  ( request -- status/f )      commit f pull-status ;
: OK\      ( request -- ? )             commit pull-OK ;
: bytes\   ( request -- byte-vector/f ) commit pull-bytes ;
: string\  ( request -- string/f )      commit pull-string ;
: integer\ ( request -- int/f )         commit pull-integer ;
: bulk\    ( request -- string/f ? )    commit pull-bulk ;
: multi\   ( request -- seq/f ? )       commit pull-multi ;

ALIAS: b\ bytes\
ALIAS: s\ string\
ALIAS: i\ integer\

UNION: redis-address inet mock-address ;

TUPLE: redis
    { address redis-address initial: mock-address }
    password ;

SYMBOL: current-redis

<PRIVATE
CONSTANT: (default-port) 6379

ERROR: (bad-login) ;
ERROR: (mock-session) ;
PRIVATE>

: <redis-session> ( redis quot -- session )
    over address>> mock-address? [ (mock-session) ] [
        swap password>> [
            [ \auth OK\ [ (bad-login) ] unless drop ] when*
        ] curry prepose
    ] if ; inline

! ______________
! initialization

: <redis> ( host -- redis )
    (default-port) <inet> f redis boa ;

: <local-redis> ( -- redis ) "127.0.0.1" <redis> ;

<local-redis> current-redis set-global

! __________________
! blocking interface

: with-redis-session ( redis quot -- )
    [ [ address>> binary ] keep ]
    [ <redis-session> with-client ] bi* ; inline

: with-redis ( redis quot -- )
    [ address>> binary ] dip
    pick mock-address? [ with-mocker ] [ with-client ] if ; inline

: with-current-redis ( quot -- )
    current-redis get-global swap with-redis ; inline

: select-keys ( pattern -- names )
    >\keys multi\ [ [ >string ] map ] [ drop f ] if ;

! ______________________
! non-blocking interface

: (detach-worker) ( request quot: ( request -- response ) promise -- )
    [ with-current-redis ] [ fulfill ] bi* ; inline

: detach ( request quot: ( request -- response ) -- thread promise )
    swap <promise> [
        swapd [ (detach-worker) ] 3curry
    ] 2keep [ spawn ] dip ; inline

: (redis-worker) ( redis quot: ( -- response ) promise -- )
    [ with-redis ] [ fulfill ] bi* ; inline
 
: promise-with-redis ( redis quot: ( -- response ) -- thread promise )
    <promise> [
        [ (redis-worker) ] 3curry
        "promise-with-redis" spawn
    ] keep ; inline

: (current-redis-worker) ( quot: ( -- response ) promise -- )
    [ with-current-redis ] [ fulfill ] bi* ; inline
 
: promise-with-current-redis ( quot: ( -- response ) -- thread promise )
    <promise> [
        [ (current-redis-worker) ] 2curry
        "promise-with-current-redis" spawn
    ] keep ; inline
