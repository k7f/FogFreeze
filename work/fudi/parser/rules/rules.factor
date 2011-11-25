! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: arrays fry kernel lexer namespaces parser sequences ;
IN: fudi.parser.rules

<PRIVATE
<<
SYMBOL: (parse-rules) [ 3drop ] 1array (parse-rules) set-global
>>
PRIVATE>

: parse-rules ( -- rules ) (parse-rules) get-global ;

! FIXME replace if already added
! FIXME validate the stack effect: ( selector quot: ( fudi tail -- ) -- )
SYNTAX: FUDI-RULE:
    scan-token "=>" expect
    dup length head-slice '[ dup _ = ]
    parse-definition [ drop ] prepose 2array
    (parse-rules) [ swap prefix ] with change-global ;
