! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: assocs http.client io io.directories io.encodings.utf8 io.files
       json.reader kernel math math.order math.parser sequences sorting
       splitting strings unicode.case urls urls.encoding ;
IN: jp.redis.updater

! FIXME handle command arguments (sort and sorted sets) and optional arguments

<PRIVATE
CONSTANT: (commands-url) "https://github.com/antirez/redis-doc/raw/master/commands.json"
CONSTANT: (max-version) { 2 4 0 }

: commands-url ( -- url )
    (commands-url) url-encode >url ;

: commands ( -- assoc )
    commands-url http-get nip json> ;

! FIXME
: arguments ( command -- args/f )
    "arguments" swap at [
        "command" over key? [ drop f ] [
            "optional" swap key? not
        ] if
    ] filter ;

: since ( command -- version )
    "since" swap at "." split [ string>number ] map ;

: not-yet? ( command -- ? )
    since (max-version) after? ;

: print-header ( -- )
    "! Do not edit.  This file has been generated from\n! \""
    (commands-url) "\".\n" 3append print
    "IN: jp.redis.formatter\n" print ;

: proper-name ( name -- name' )
    >lower { { CHAR: space CHAR: - } } substitute ;

: print-name ( name-align name -- )
    [ proper-name ": rq2-" prepend write ]
    [ length - ] bi CHAR: space <repetition> >string write ;

: (arg-name) ( arg -- string )
    "name" swap at dup string? [ "-" join ] unless ;

: (args-names) ( command -- string count )
    arguments [ "" 0 ] [
        [ (arg-name) ] map
        [ " " join ] [ length ] bi
    ] if-empty ;

: (args-length) ( command -- n )
    (args-names) drop length ;

: print-effect ( command args-align -- )
    [ (args-names) drop dup length ] [ swap - ] bi*
    CHAR: space <repetition> append
    " ( " " -- request ) " surround write ;

: print-definition ( name command -- )
    [ "\"" dup surround write ]
    [ (args-names) nip number>string " " "format-multi" surround write ] bi* ;

: print-command ( name command name-align args-align -- )
    [ pick print-name dup ] dip print-effect
    print-definition " ; inline " print ;

: print-commands ( name-align assoc -- )
    [ values [ (args-length) ] [ max ] map-reduce ]
    [ -rot [ print-command ] 2curry assoc-each ] bi ;
PRIVATE>

: print-all ( -- )
    commands [ nip not-yet? not ] assoc-filter sort-keys [
        print-header
        [ keys [ length ] [ max ] map-reduce ]
        [ print-commands ] bi
    ] when* ;

: generate-words ( -- )
    "vocab:jp/redis/updater/formatter" [
        "formatter.factor" utf8 [ print-all ] with-file-writer
    ] with-directory ;

MAIN: generate-words
