! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors addenda.errors addenda.math ascii kernel math math.parser
       math.ranges parser sequences splitting strings words words.symbol ;
IN: om.rhythm.meter

TUPLE: meter { num number } { den number } ;

: <meter> ( num den -- mtr ) meter boa ;

GENERIC: >meter ( obj -- mtr )

M: meter >meter ( mtr -- mtr ) ;

<PRIVATE
: (meter-separator) ( char -- ? )
    dup digit? [ drop f ] [
        dup CHAR: / =
         [ drop t ] [ 1string invalid-input ] if
    ] if ;
PRIVATE>

M: string >meter ( str -- mtr )
    dup [ (meter-separator) ] split-when
    dup length 3 = [ nip ] [ drop invalid-input ] if
    [ first ] [ third ] bi [ string>number ] bi@ <meter> ;

M: sequence >meter ( seq -- mtr ) first2 <meter> ; inline

M: meter >rational ( mtr -- dur )
    [ num>> ] [ den>> ] bi / >rational ; inline

<<
<PRIVATE
: (define-meter-word) ( num den -- )
    [ number>string ] bi@ "//" glue
    [ create-in ] [ [ >meter ] curry ] bi
    ( -- mtr ) define-declared ;
PRIVATE>

19 [1,b] 7 iota [ 2^ (define-meter-word) ] cartesian-each
>>
