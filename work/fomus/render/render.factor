! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors combinators debugger fomus.lli io io.backend io.pathnames
       kernel math sequences strings timidity ;
IN: fomus.render

<PRIVATE
ERROR: (bad-extension) { given string read-only } ;
M: (bad-extension) error. "Bad file extension given: " write given>> print ;

: (fomus-render) ( path -- smf-path )
    normalize-path {
        [ ".fms" append fomus-do-save ]
        [ ".xml" append fomus-run-file ]
        [ ".ly" append fomus-run-file ]
        [ ".mid" append dup fomus-run-file ]
    } cleave ;
PRIVATE>

: fomus-render ( path -- )
    dup file-extension [ normalize-path fomus-run-file ] [ (fomus-render) drop ] if ;

: fomus-play ( path -- )
    dup file-extension [
        dup "mid" = [ drop normalize-path ] [ (bad-extension) ] if
    ] [ normalize-path ".mid" append ] if*
    [ fomus-run-file ] [ play ] bi ;

: fomus-render&play ( path -- )
    dup file-extension [
        [ normalize-path [ fomus-run-file ] keep ] dip
        dup "mid" = [ drop play ] [
            length 1 + head* ".mid" append [ fomus-run-file ] [ play ] bi
        ] if
    ] [ (fomus-render) play ] if* ;
