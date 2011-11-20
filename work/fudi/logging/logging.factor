! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors fry io kernel lexer logging macros namespaces sequences
       strings words ;
IN: fudi.logging

<PRIVATE
: (info+string) ( fudi string -- string' ) swap "info" word-prop prepend ; inline
: (string+info) ( string fudi -- string' ) "info" word-prop append ; inline
PRIVATE>

: bi-info ( first second -- string )
    dup string? [ (info+string) ] [ (string+info) ] if ; inline

: bi-print ( first second -- )
    swap dup string?
    [ write "info" word-prop print ]
    [ "info" word-prop write print ] if ; inline

<PRIVATE
CONSTANT: (+log-name+) "fudi"
PRIVATE>

: fudi-logging? ( -- ? ) log-service get (+log-name+) = ;

: with-fudi-logging ( quot -- ) (+log-name+) swap with-logging ; inline

<PRIVATE
MACRO: (fudi-log) ( level -- )
    dup name>> ": " append '[
        [ fudi-logging? swap and ] [ f ] if*
        [ _ log-message ]
        [ _ write print ] if*
    ] ;

MACRO: (fudi-log*) ( level -- ) [ log-message ] curry ;

MACRO: (bi-log) ( level -- )
    dup name>> ": " append '[
        [ fudi-logging? swap and ] [ f ] if*
        [ [ bi-info ] dip _ log-message ]
        [ _ write bi-print ] if*
    ] ;

MACRO: (bi-log*) ( level -- ) '[ [ bi-info ] dip _ log-message ] ;
PRIVATE>

: fudi-DEBUG   ( message word/f -- ) DEBUG   (fudi-log) ;
: fudi-NOTICE  ( message word/f -- ) NOTICE  (fudi-log) ;
: fudi-WARNING ( message word/f -- ) WARNING (fudi-log) ;
: fudi-ERROR   ( message word/f -- ) ERROR   (fudi-log) ;

: fudi-DEBUG*   ( message word/f -- ) DEBUG   (fudi-log*) ; inline
: fudi-NOTICE*  ( message word/f -- ) NOTICE  (fudi-log*) ; inline
: fudi-WARNING* ( message word/f -- ) WARNING (fudi-log*) ; inline
: fudi-ERROR*   ( message word/f -- ) ERROR   (fudi-log*) ; inline

: bi-DEBUG   ( first second word/f -- ) DEBUG   (bi-log) ;
: bi-NOTICE  ( first second word/f -- ) NOTICE  (bi-log) ;
: bi-WARNING ( first second word/f -- ) WARNING (bi-log) ;
: bi-ERROR   ( first second word/f -- ) ERROR   (bi-log) ;

: bi-DEBUG*   ( first second word/f -- ) DEBUG   (bi-log*) ; inline
: bi-NOTICE*  ( first second word/f -- ) NOTICE  (bi-log*) ; inline
: bi-WARNING* ( first second word/f -- ) WARNING (bi-log*) ; inline
: bi-ERROR*   ( first second word/f -- ) ERROR   (bi-log*) ; inline
