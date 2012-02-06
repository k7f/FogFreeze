! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: arrays combinators kernel lexer locals math math.parser om.support
       parser sequences vectors words ;
IN: om.syntax

<PRIVATE
DEFER: (lparse-literal)

: (lparse-datum) ( string -- word/number/string )
    {
        { "\"" [ \ " ] }
        { "CHAR:" [ \ CHAR: ] }
        [ dup string>number [ ] [ ] ?if ]
    } case ;

:: (lparse-step) ( accum quot begin end current -- ? )
    {
        { [ current end equal? ] [ f ] }
        { [ current begin equal? ] [ quot begin end (lparse-literal) accum push t ] }
        { [ current not ] [ end unexpected-eof t ] }
        { [ current delimiter? ] [ end current unexpected t ] }
        { [ current parsing-word? ] [ accum current execute-parsing drop t ] }
        { [ current number? ] [ current accum push t ] }
        [ current cl-symbol boa accum push t ]
    } cond ;

:: (lparse-until) ( accum quot begin end -- )
    accum quot begin end
    (scan-token) dup [ (lparse-datum) ] when (lparse-step)
    [ accum quot begin end (lparse-until) ] when ;

: (lparse-literal) ( quot begin end -- accum )
    [ 100 <vector> swap 2dup ] 2dip (lparse-until) call( accum -- accum' ) ;
PRIVATE>

SYNTAX: '( [ >array ] "(" ")" (lparse-literal) suffix! ;
