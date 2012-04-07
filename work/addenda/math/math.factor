! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.errors classes kernel math math.functions sequences ;
IN: addenda.math

: nonnegative-integer! ( obj -- num/* )
    [ integer? ] [
        swap [
            dup 0 < [ "negative integer" invalid-input ] when
        ] [ class-of invalid-input ] if
    ] bi ; inline

: >power-of-2 ( m -- n )
    dup 0 > [ log2 2^ ] [ drop 0 ] if ; inline

GENERIC: >rational ( obj -- rat )

M: rational >rational ( n   -- rat ) ; inline
M: float    >rational ( n   -- rat ) round >integer ; inline

M: sequence >rational ( seq -- rat )
    dup length 1 > [ first2 / ] [ first ] if >rational ;
