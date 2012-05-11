! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: jp.redis.formatter strings tools.test ;
IN: jp.redis.formatter.tests

[ "GET abc\r\n" ] [
    "abc" rq-get >string
] unit-test

[ "RENAME abc xyz\r\n" ] [
    "abc" "xyz" rq-rename >string
] unit-test

[ "SET xyz 3\r\n123\r\n" ] [
    "xyz" 123 rq-set >string
] unit-test

[ "LRANGE pqr 77 777\r\n" ] [
    "pqr" 77 777 rq-lrange >string
] unit-test

[ "LSET pqr 45 4\r\n6789\r\n" ] [
    "pqr" 45 6789 rq-lset >string
] unit-test

[ "*2\r\n$3\r\nGET\r\n$3\r\nabc\r\n" ] [
    "abc" rq2-get >string
] unit-test

[ "*3\r\n$6\r\nRENAME\r\n$3\r\nabc\r\n$3\r\nxyz\r\n" ] [
    "abc" "xyz" rq2-rename >string
] unit-test

[ "*3\r\n$3\r\nSET\r\n$3\r\nxyz\r\n$3\r\n123\r\n" ] [
    "xyz" 123 rq2-set >string
] unit-test

[ "*4\r\n$6\r\nLRANGE\r\n$3\r\npqr\r\n$2\r\n77\r\n$3\r\n777\r\n" ] [
    "pqr" 77 777 rq2-lrange >string
] unit-test

[ "*4\r\n$4\r\nLSET\r\n$3\r\npqr\r\n$2\r\n45\r\n$4\r\n6789\r\n" ] [
    "pqr" 45 6789 rq2-lset >string
] unit-test

[ "*5\r\n$7\r\nLINSERT\r\n$3\r\npqr\r\n$5\r\nAFTER\r\n$4\r\n6789\r\n$4\r\n7890\r\n" ] [
    "pqr" "AFTER" 6789 7890 rq2-linsert >string
] unit-test
