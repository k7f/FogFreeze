! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors debugger ff.strains io kernel math prettyprint sequences ;
IN: ff.strains.simple

STRAIN: overflow { value real } { limit real } ;

: <overflow> ( limit -- strain )
    \ overflow new-strain 0 >>max-failures swap >>limit ;

: set-overflow ( chain guard limit/f -- )
    dup [ <overflow> swap >>max-failures ] [ nip ] if
    overflow set-strain ;

M: overflow strain=
    [ limit>> ] bi@ = ; inline

M: overflow check
    2dup limit>> [
        > [ over >>value strain-check-failure ] [ drop f ] if
    ] [ 2drop f ] if* ; inline

M: overflow error.
    "Value " write dup value>> pprint
    " is over the limit of " write limit>> . ;

STRAIN: underflow { value real } { limit real } ;

: <underflow> ( limit -- strain )
    \ underflow new-strain 0 >>max-failures swap >>limit ;

: set-underflow ( chain guard limit/f -- )
    dup [ <underflow> swap >>max-failures ] [ nip ] if
    underflow set-strain ;

M: underflow strain=
    [ limit>> ] bi@ = ; inline

M: underflow check
    2dup limit>> [
        < [ over >>value strain-check-failure ] [ drop f ] if
    ] [ 2drop f ] if* ; inline

M: underflow error.
    "Value " write dup value>> pprint
    " is under the limit of " write limit>> . ;
