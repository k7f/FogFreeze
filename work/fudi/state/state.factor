! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: fudi.logging kernel prettyprint ;
IN: fudi.state

<PRIVATE
SYMBOLS: (locals) (remotes) ;
PRIVATE>

: update-remotes ( name object -- )
    unparse [ \ update-remotes fudi-DEBUG ] bi@ ;
