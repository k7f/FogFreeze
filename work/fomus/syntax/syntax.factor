! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: fomus.lli kernel lexer parser sequences words ;
IN: fomus.syntax

<PRIVATE
: (define-mark) ( mark -- )
    [ "M[" "]" surround create-in ] keep
    [ fomus-set-mark-id fomus-add-mark ] curry
    ( -- ) define-declared ;
PRIVATE>

SYNTAX: FOMUS-MARK: scan-token (define-mark) ;
SYNTAX: FOMUS-MARKS: ";" [ (define-mark) ] each-token ;
