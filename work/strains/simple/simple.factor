! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors debugger io kernel math prettyprint sequences strains ;
IN: strains.simple

TUPLE: overloop < strain { count fixnum } { limit fixnum } ;
: <overloop> ( limit -- strain )
    1 - \ overloop new-strain 0 >>max-failures swap >>limit ;
M: overloop strain=
    [ limit>> ] bi@ = ; inline

M: overloop check
    pick over limit>> [
        swap length < [
            pick length >>count
            call-next-method
        ] [ drop f ] if
    ] [ 2drop f ] if* ; inline

M: overloop error.
    "Iteration #" write dup count>> 1 + pprint
    " exceeds the limit of " write limit>> 1 + pprint " elements" print ;

TUPLE: overflow < strain { value real } { limit real } ;
: <overflow> ( limit -- strain )
    \ overflow new-strain 0 >>max-failures swap >>limit ;
M: overflow strain=
    [ limit>> ] bi@ = ; inline

M: overflow check
    2dup limit>> [
        > [ over >>value call-next-method ] [ drop f ] if
    ] [ 2drop f ] if* ; inline

M: overflow error.
    "Value " write dup value>> pprint
    " is over the limit of " write limit>> . ;

TUPLE: underflow < strain { value real } { limit real } ;
: <underflow> ( limit -- strain )
    \ underflow new-strain 0 >>max-failures swap >>limit ;
M: underflow strain=
    [ limit>> ] bi@ = ; inline

M: underflow check
    2dup limit>> [
        < [ over >>value call-next-method ] [ drop f ] if
    ] [ 2drop f ] if* ; inline

M: underflow error.
    "Value " write dup value>> pprint
    " is under the limit of " write limit>> . ;
