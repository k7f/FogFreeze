! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: continuations io.streams.string jp.redis.reader jp.redis.reader.private
       tools.test ;
IN: jp.redis.reader.tests

[ t f ] [
    "+OK\r\n+ok\r\n" [ pull-OK pull-OK ] with-string-reader
] unit-test

[ f t ] [
    "+OK\r\n+ok\r\n" [ "ok" pull-status "ok" pull-status ] with-string-reader
] unit-test

[ "OK" f ] [
    "+OK\r\n:ok\r\n" [ f pull-status f pull-status ] with-string-reader
] unit-test

[ 123 ] [
    ":123\r\n+123\r\n" [ pull-integer ] with-string-reader
] unit-test

[ "OK" t ] [
    "$2\r\nOK\r\n" [ pull-bulk ] with-string-reader
] unit-test

[ { "OK" f "ok" } t ] [
    "*3\r\n$2\r\nOK\r\n$-1\r\n$2\r\nok\r\n" [ pull-multi ] with-string-reader
] unit-test

[ T{ (error-reply) f f "7" } ] [
    [ "-7\r\n" [ pull-anything ] with-string-reader ] [ ] recover
] unit-test
