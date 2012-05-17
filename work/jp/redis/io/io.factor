! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: io jp.redis kernel ;
IN: jp.redis.io

: stream>redis ( key stream -- ? )
    stream-contents >\set OK\ ; inline

: redis>stream ( key stream -- ? )
    [ >\get b\ ] [
        over [ [ write ] with-output-stream t ] [ drop ] if
    ] bi* ; inline
