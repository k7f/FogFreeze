! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: jp.redis.formatter strings tools.test ;

IN: jp.redis
<< use-old-protocol >>

IN: jp.redis.tests

[ "GET abc\r\n" ] [
    \get abc >string
] unit-test

[ "GET abc\r\n" ] [
    "abc" >\get >string
] unit-test

[ "RENAME abc xyz\r\n" ] [
    \rename abc xyz >string
] unit-test

[ "RENAME abc xyz\r\n" ] [
    "abc" "xyz" >\rename >string
] unit-test

[ "SET xyz 3\r\n123\r\n" ] [
    \set xyz 123 >string
] unit-test

[ "SET xyz 3\r\n123\r\n" ] [
    "xyz" 123 >\set >string
] unit-test

[ "LRANGE pqr 77 777\r\n" ] [
    \lrange pqr 77 777 >string
] unit-test

[ "LRANGE pqr 77 777\r\n" ] [
    "pqr" 77 777 >\lrange >string
] unit-test

[ "LSET pqr 45 4\r\n6789\r\n" ] [
    \lset pqr 45 6789 >string
] unit-test

[ "LSET pqr 45 4\r\n6789\r\n" ] [
    "pqr" 45 6789 >\lset >string
] unit-test

IN: jp.redis
<< use-new-protocol >>

IN: jp.redis.tests

[ "*2\r\n$3\r\nGET\r\n$3\r\nabc\r\n" ] [
    \get abc >string
] unit-test

[ "*2\r\n$3\r\nGET\r\n$3\r\nabc\r\n" ] [
    "abc" >\get >string
] unit-test

[ "*3\r\n$6\r\nRENAME\r\n$3\r\nabc\r\n$3\r\nxyz\r\n" ] [
    \rename abc xyz >string
] unit-test

[ "*3\r\n$6\r\nRENAME\r\n$3\r\nabc\r\n$3\r\nxyz\r\n" ] [
    "abc" "xyz" >\rename >string
] unit-test

[ "*3\r\n$3\r\nSET\r\n$3\r\nxyz\r\n$3\r\n123\r\n" ] [
    \set xyz 123 >string
] unit-test

[ "*3\r\n$3\r\nSET\r\n$3\r\nxyz\r\n$3\r\n123\r\n" ] [
    "xyz" 123 >\set >string
] unit-test

[ "*4\r\n$6\r\nLRANGE\r\n$3\r\npqr\r\n$2\r\n77\r\n$3\r\n777\r\n" ] [
    \lrange pqr 77 777 >string
] unit-test

[ "*4\r\n$6\r\nLRANGE\r\n$3\r\npqr\r\n$2\r\n77\r\n$3\r\n777\r\n" ] [
    "pqr" 77 777 >\lrange >string
] unit-test

[ "*4\r\n$4\r\nLSET\r\n$3\r\npqr\r\n$2\r\n45\r\n$4\r\n6789\r\n" ] [
    \lset pqr 45 6789 >string
] unit-test

[ "*4\r\n$4\r\nLSET\r\n$3\r\npqr\r\n$2\r\n45\r\n$4\r\n6789\r\n" ] [
    "pqr" 45 6789 >\lset >string
] unit-test

[ "*5\r\n$7\r\nLINSERT\r\n$3\r\npqr\r\n$5\r\nAFTER\r\n$4\r\n6789\r\n$4\r\n7890\r\n" ] [
    "pqr" "AFTER" 6789 7890 >\linsert >string
] unit-test
