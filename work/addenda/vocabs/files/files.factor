! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: io.directories io.files io.pathnames kernel sequences vocabs.loader ;
IN: addenda.vocabs.files

: vocab-tests-dir* ( vocab extension -- paths/f )
    over vocab-dir "tests" append-path
    swapd vocab-append-path dup [
        dup exists? [
            swap [ dup directory-files ] dip
            [ tail? ] curry filter
            [ append-path ] with map
        ] [ 2drop f ] if
    ] [ 2drop f ] if ;
