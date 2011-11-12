! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: io io.backend io.pathnames sequences timidity ;
IN: timidity.demo

<PRIVATE
: (full-demo-path) ( -- path )
    "timidity" vocab-path "/demo/demo.mid" append normalize-path ;
PRIVATE>

: demo! ( -- )
    "v" [ 150 [ (full-demo-path) play! ] with-tempo ] with-verbosity ;

: demo ( -- )
    "timidity demo: execute \"USE: timidity stop\" when bored... " print
    125 [ (full-demo-path) play ] with-tempo ;

MAIN: demo
