! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors debugger io kernel math prettyprint sequences sets strains ;
IN: strains.generic

STRAIN: overdepth { count fixnum } { limit fixnum } ;

: <overdepth> ( limit -- strain )
    1 - \ overdepth new-strain 0 >>max-failures swap >>limit ;

: set-overdepth ( chain guard limit/f -- )
    dup [ <overdepth> swap >>max-failures ] [ nip ] if
    overdepth set-strain ;

M: overdepth strain=
    [ limit>> ] bi@ = ; inline

M: overdepth check
    pick over limit>> [
        swap length < [
            pick length >>count
            call-next-method
        ] [ drop f ] if
    ] [ 2drop f ] if* ; inline

M: overdepth error.
    "Iteration #" write dup count>> 1 + pprint
    " exceeds the limit of " write limit>> 1 + pprint " elements" print ;

STRAIN: all-different ;

: <all-different> ( -- strain )
    \ all-different new-strain ;

: set-all-different ( chain guard/f -- )
    dup [ <all-different> swap >>max-failures ] when
    all-different set-strain ;

M: all-different check
    pick pick swap member? [ call-next-method ] [ drop f ] if ; inline

M: all-different error.
    drop "The \"all different\" goal not reached" print ;

STRAIN: all-different-delta { state sequence } ;

: <all-different-delta> ( -- strain )
    [ "push" . ] [ "pop" . ] \ all-different-delta new-vstrain ;

: set-all-different-delta ( chain guard/f -- )
    dup [ <all-different-delta> swap >>max-failures ] when
    all-different-delta set-strain ;

M: all-different-delta check
    pick pick swap member? [ call-next-method ] [ drop f ] if ; inline

M: all-different-delta error.
    drop "The \"all different (delta)\" goal not reached" print ;
