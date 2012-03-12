! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors ascii kernel math math.parser math.ranges parser sequences
       splitting strings words.symbol ;
IN: om.rhythm.meter

TUPLE: meter { num number } { den number } ;

: <meter> ( num den -- mtr ) meter boa ;

GENERIC: >meter ( obj -- mtr )

M: meter >meter ( mtr -- mtr ) ;

M: string >meter ( str -- mtr )
    [ digit? not ] split-when harvest
    first2 [ string>number ] bi@ <meter> ;

M: sequence >meter ( seq -- mtr ) first2 <meter> ;

M: symbol >meter ( sym -- mtr ) name>> >meter ;

<<
<PRIVATE
: (define-meter-symbol) ( num den -- )
    [ number>string ] bi@ "//" glue create-in define-symbol ;
PRIVATE>

19 [1,b] 7 iota [ 2^ (define-meter-symbol) ] cartesian-each
>>
