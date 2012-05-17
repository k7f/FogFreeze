! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: jp.redis jp.redis.io.files kernel sequences tools.test vocabs.files ;
IN: jp.redis.io.files.tests

[ "OK" ] [
    "jp.redis.io.files" vocab-files first dup
    redis new [ file>redis ] with-redis
] unit-test
