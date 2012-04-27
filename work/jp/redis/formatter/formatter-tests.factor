! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: jp.redis.formatter tools.test ;
IN: jp.redis.formatter.tests

[ "GET abc\r\n" ] [
    \get abc
] unit-test

[ "RENAME abc xyz\r\n" ] [
    \rename abc xyz
] unit-test

[ "SET xyz 3\r\n123\r\n" ] [
    \set xyz 123
] unit-test

[ "LRANGE pqr 77 777\r\n" ] [
    \lrange pqr 77 777
] unit-test

[ "LSET pqr 45 4\r\n6789\r\n" ] [
    \lset pqr 45 6789
] unit-test
