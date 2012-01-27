! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: classes ff.errors kernel math ;
IN: ff.assertions

: nonnegative-integer! ( num -- num )
    [ integer? ] [
        swap [
            dup 0 < [ "negative integer" invalid-input ] when
        ] [ class-of invalid-input ] if
    ] bi ; inline
