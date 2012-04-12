! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: assocs classes combinators io io.streams.string kernel math.parser
       prettyprint.backend prettyprint.custom prettyprint.sections sequences
       strings vectors ;
IN: addenda.prettyprint

GENERIC: deep-pprint* ( obj -- )

M: object deep-pprint* pprint* ;

: deep-pprint-elements ( seq -- )
    do-length-limit
    [ [ deep-pprint* ] each ] dip
    [ number>string "~" " more~" surround text ] when* ;

M: sequence deep-pprint* ( obj -- )
    [
        <flow
        dup pprint-delims [
            pprint-word
            dup pprint-narrow? <inset
            >pprint-sequence deep-pprint-elements
            block>
        ] dip pprint-word block>
    ] check-recursion ;

: deep-pprint-slot-value ( name value -- )
    <flow \ { pprint-word
    [ text ] [ f <inset deep-pprint* block> ] bi*
    \ } pprint-word block> ;

: (deep-pprint-tuple) ( opener class slots closer -- )
    <flow {
        [ pprint-word ]
        [ pprint-word ]
        [ t <inset [ deep-pprint-slot-value ] assoc-each block> ]
        [ pprint-word ]
    } spread block> ;

: deep-pprint-tuple ( tuple -- )
    [
        [ \ T{ ] dip [ class-of ] [ tuple>assoc ] bi
        \ } (deep-pprint-tuple)
    ] ?pprint-tuple ;

M: tuple deep-pprint* deep-pprint-tuple ;

: .tuple ( tuple -- ) [ deep-pprint-tuple ] with-pprint nl ;

: unparse-tuple ( tuple -- string )
    [ [ deep-pprint-tuple ] with-pprint ] with-string-writer
    dup length <vector> [
        dup CHAR: \n = [ drop CHAR: space ] when
        dup CHAR: space = [
            over ?last CHAR: space = [ drop ] [ suffix! ] if
        ] [ suffix! ] if
    ] reduce >string ;
