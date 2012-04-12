! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: eval io.streams.string kernel prettyprint sequences ;
IN: addenda.eval

: eval-using ( str vocabs effect -- )
    [ " " join "USING: " " ; " surround prepend ] dip eval ; inline

: eval-literal ( str vocabs -- obj )
    ( -- obj ) eval-using ;

: (over-parse-literal) ( str vocabs -- obj str' )
    eval-literal [ [ pprint ] with-string-writer ] keep swap ; inline

: over-parse-literal ( str vocabs -- obj obj' )
    2dup [ (over-parse-literal) ] 2dip
    swap pick = [ 2drop dup ] [ eval-literal ] if ;

: ?eval-literal ( str vocabs -- obj ? )
    over-parse-literal 2dup eq? [ drop t ] [
        2dup = [ drop f ] unless
    ] if ;
