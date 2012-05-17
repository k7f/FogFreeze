! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: io.streams.string jp.redis jp.redis.io kernel tools.test ;
IN: jp.redis.io.tests

[ "OK" ] [
    "key" "value" <string-reader>
    redis new [ stream>redis ] with-redis
] unit-test

[ t ] [
    "key" <string-writer>
    redis new [ redis>stream ] with-redis
] unit-test
