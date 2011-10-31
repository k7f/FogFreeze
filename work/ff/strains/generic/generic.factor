! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors arrays classes.parser classes.tuple classes.tuple.parser
       classes combinators compiler.units debugger ff ff.strains fry generic.parser
       io kernel lexer macros make math parser prettyprint quotations sequences
       sets words ;
IN: ff.strains.generic

STRAIN: overdepth { count fixnum } { limit fixnum } ;

: <overdepth> ( limit -- strain )
    1 - \ overdepth new-strain 0 >>max-failures swap >>limit ;

: set-overdepth ( chain guard/f limit -- chain' )
    <overdepth> swap >>max-failures overdepth set-strain ;

: clear-overdepth ( chain -- chain' ) f overdepth set-strain ;

M: overdepth strain=
    [ limit>> ] bi@ = ; inline

M: overdepth check
    pick over limit>> [
        swap length < [
            pick length >>count
            strain-check-failure
        ] [ drop f ] if
    ] [ 2drop f ] if* ; inline

M: overdepth error.
    "Iteration #" write dup count>> 1 + pprint
    " exceeds the limit of " write limit>> 1 + pprint " elements" print ;

STRAIN: all-different ;

: <all-different> ( -- strain )
    \ all-different new-strain ;

: set-all-different ( chain guard/f -- chain' )
    <all-different> swap >>max-failures all-different set-strain ;

: clear-all-different ( chain -- chain' ) f all-different set-strain ;

M: all-different check
    pick pick swap member? [ strain-check-failure ] [ drop f ] if ; inline

M: all-different error.
    drop "The \"all different\" condition not fulfilled" print ;

STRAIN: all-different2 { bistack sequence } ;

<PRIVATE
: (create-binop-push) ( class -- quot: ( hitstack value strain -- ) )
    "binop" word-prop '[
        bistack>> dup [
            pick empty? [ 3drop ] [ [ swap last @ ] dip push ] if
        ] dip get-trace [ "(binop-push): " write . ] [ drop ] if
    ] ;

: (create-binop-drop) ( class -- quot: ( strain -- ) )
    drop [
        bistack>> dup [ pop* ] unless-empty
        get-trace [ "(binop-drop): " write . ] [ drop ] if
    ] ;
PRIVATE>

: new-all-different2 ( class -- strain )
    [ (create-binop-push) ] [ (create-binop-drop) ] [ new-stateful-strain ] tri
    V{ } clone >>bistack ;

: set-all-different2 ( chain guard/f class -- chain' )
    [ new-all-different2 swap >>max-failures ] keep set-strain ;

: clear-all-different2 ( chain class -- chain' ) f swap set-strain ;

MACRO: all-different2-check ( class -- )
    "binop" word-prop '[
         pick last pick swap @
        dup 0 = [ drop strain-check-failure ] [
            over bistack>> member? [ strain-check-failure ] [ drop f ] if
        ] if
    ] ;

M: all-different2 error.
    "The \"all different (" write class-of name>> write ")\" condition not fulfilled" print ;

<PRIVATE
: (define-chain-in) ( class -- )
    [ name>> "set-" prepend create-in dup reset-generic ] keep
    [ set-all-different2 ] curry
    ( chain guard/f -- chain' )
    define-declared ;

: (define-chain-out) ( class -- )
    [ name>> "clear-" prepend create-in dup reset-generic ] keep
    [ clear-all-different2 ] curry
    ( chain -- chain' )
    define-declared ;

: (define-chain-setters) ( class -- )
    [ (define-chain-in) ] [ (define-chain-out) ] bi ;

: (define-check-method) ( class -- )
    [ \ check create-method-in dup reset-generic ] keep
    [ all-different2-check ] curry
    define ;

: (parse-all-different2-definition) ( -- class )
    scan-new-class [
        parse-definition "binop" set-word-prop
    ] keep ; inline
PRIVATE>

SYNTAX: ALL-DIFFERENT2:
    (parse-all-different2-definition) [
        all-different2 f define-tuple-class
    ] [ (define-chain-setters) ] [ (define-check-method) ] tri ;
