! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors debugger io kernel prettyprint sequences sets  strains ;
IN: strains.generic

TUPLE: all-different < strain ;

: <all-different> ( -- strain )
    \ all-different new-strain ;

: set-all-different ( chain guard/f -- )
    dup [ <all-different> swap >>max-failures ] when
    all-different set-strain ;

M: all-different check
    pick all-unique? [ drop f ] [ call-next-method ] if ; inline

M: all-different error.
    drop "The \"all different\" goal not reached" print ;
