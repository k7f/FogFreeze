! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: eval sequences ;
IN: addenda.eval

: eval-using ( token vocabs -- obj )
    " " join "USING: " " ; " surround prepend ( -- obj ) eval ;
