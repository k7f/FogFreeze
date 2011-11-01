! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors debugger ff.strains io kernel math prettyprint sequences ;
IN: ff.strains.simple

STRAIN: overflow { value real } { limit real } ;

: <overflow> ( guard/f limit -- strain )
    \ overflow new-strain swap >>limit swap >>max-failures ;

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

: <underflow> ( guard/f limit -- strain )
    \ underflow new-strain swap >>limit swap >>max-failures ;

M: underflow strain=
    [ limit>> ] bi@ = ; inline

M: underflow check
    2dup limit>> [
        < [ over >>value strain-check-failure ] [ drop f ] if
    ] [ 2drop f ] if* ; inline

M: underflow error.
    "Value " write dup value>> pprint
    " is under the limit of " write limit>> . ;
