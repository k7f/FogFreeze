! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: fomus.ffi fomus.lli fomus.lli.private kernel namespaces ;
IN: fomus

: fomus-start ( -- )
    (fomus-initialized?) get-global [
        (fomus_init) t (fomus-initialized?) set-global
    ] unless ;

: <fomus> ( -- fomus )
    (fomus-initialized?) get-global [ (fomus_new) ] [ (fomus-not-initialized) ] if ;

: with-fomus ( fomus quot -- )
    swap (fomus-instance) set call (fomus-instance) get (fomus_free) ; inline
