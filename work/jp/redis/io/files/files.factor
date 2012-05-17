! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: io.encodings.binary io.files jp.redis.io ;
IN: jp.redis.io.files

: file>redis ( key path -- ? )
    binary <file-reader> stream>redis ; inline

: redis>file ( key path -- ? )
    binary <file-writer> redis>stream ; inline
