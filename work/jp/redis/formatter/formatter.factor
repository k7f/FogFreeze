! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors assocs effects kernel lexer math math.parser parser
       sequences strings vocabs words ;
IN: jp.redis.formatter

! FIXME use the 2.x protocol by default, 1.x on demand

<PRIVATE
DEFER: (append!)

GENERIC:  (convert) ( value -- value' )
M: string (convert) ( value -- value ) ; inline
M: number (convert) ( value -- value' ) number>string ; inline

M: sequence (convert) ( seq -- value/f )
    [ f ] [
        unclip-last-slice swap [ (append!) ] each
    ] if-empty ; inline

: (append!) ( accum value -- accum )
    (convert) append! CHAR: space suffix! ; inline

: (new-command) ( command -- accum )
    [ 100 swap new-resizable ] [ (append!) ] bi ; inline

: (crlf-append!) ( accum value -- accum )
    append! "\r\n" append! ; inline

: (inline-format!) ( accum value -- accum )
    (convert) (crlf-append!) >string ; inline

: (bulk-format!) ( accum value -- accum )
    (convert) [
        length number>string (crlf-append!)
    ] [ (crlf-append!) ] bi >string ;
PRIVATE>

: format0 ( command -- request )
    [ length 2 + ] [ new-resizable ] [ (crlf-append!) ] tri >string ; inline

: format1-inline ( command argument -- request )
    [ (new-command) ] [ (inline-format!) ] bi* ; inline

: format1-bulk ( command argument -- request )
    [ (new-command) ] [ (bulk-format!) ] bi* ; inline

: format2-inline ( command argument1 argument2 -- request )
    [ (new-command) ] [ (append!) ] [ (inline-format!) ] tri* ; inline

: format2-bulk ( command argument1 argument2 -- request )
    [ (new-command) ] [ (append!) ] [ (bulk-format!) ] tri* ; inline

: format3-inline ( command argument1 argument2 argument3 -- request )
    [ [ (new-command) ] [ (append!) ] bi* ]
    [ [ (append!) ] [ (inline-format!) ] bi* ] 2bi* ; inline

: format3-bulk ( command argument1 argument2 argument3 -- request )
    [ [ (new-command) ] [ (append!) ] bi* ]
    [ [ (append!) ] [ (bulk-format!) ] bi* ] 2bi* ; inline

: rq-append      ( key value         -- request ) "APPEND" -rot format2-bulk ; inline
: rq-auth        ( password          -- request ) "AUTH" swap format1-inline ; inline
: rq-bgsave      (                   -- request ) "BGSAVE" format0 ; inline
: rq-dbsize      (                   -- request ) "DBSIZE" format0 ; inline
: rq-decr        ( key               -- request ) "DECR" swap format1-inline ; inline
: rq-decrby      ( key decrement     -- request ) "DECRBY" -rot format2-inline ; inline
: rq-del         ( key/keys          -- request ) "DEL" swap format1-inline ; inline
: rq-discard     (                   -- request ) "DISCARD" format0 ; inline
! 2.6 : rq-dump        ( key               -- request ) "DUMP" swap format1-inline ; inline
: rq-echo        ( message           -- request ) "ECHO" swap format1-bulk ; inline
: rq-exec        (                   -- request ) "EXEC" format0 ; inline
: rq-exists      ( key               -- request ) "EXISTS" swap format1-inline ; inline
: rq-expire      ( key seconds       -- request ) "EXPIRE" -rot format2-inline ; inline
: rq-expireat    ( key timestamp     -- request ) "EXPIREAT" -rot format2-inline ; inline
: rq-flushall    (                   -- request ) "FLUSHALL" format0 ; inline
: rq-flushdb     (                   -- request ) "FLUSHDB" format0 ; inline
: rq-get         ( key               -- request ) "GET" swap format1-inline ; inline
: rq-getbit      ( key offset        -- request ) "GETBIT" -rot format2-inline ; inline
: rq-getset      ( key value         -- request ) "GETSET" -rot format2-bulk ; inline
: rq-incr        ( key               -- request ) "INCR" swap format1-inline ; inline
: rq-incrby      ( key inrement      -- request ) "INCRBY" -rot format2-inline ; inline
: rq-info        (                   -- request ) "INFO" format0 ; inline
: rq-keys        ( pattern           -- request ) "KEYS" swap format1-inline ; inline
: rq-lastsave    (                   -- request ) "LASTSAVE" format0 ; inline
: rq-lindex      ( key index         -- request ) "LINDEX" -rot format2-inline ; inline
: rq-llen        ( key               -- request ) "LLEN" swap format1-inline ; inline
: rq-lpop        ( key               -- request ) "LPOP" swap format1-inline ; inline
: rq-lpush       ( key value/values  -- request ) "LPUSH" -rot format2-bulk ; inline
: rq-lrange      ( key start stop    -- request ) [ "LRANGE" ] 3dip format3-inline ; inline
: rq-lset        ( key index value   -- request ) [ "LSET" ] 3dip format3-bulk ; inline
: rq-ltrim       ( key start stop    -- request ) [ "LTRIM" ] 3dip format3-inline ; inline
: rq-mget        ( key/keys          -- request ) "MGET" swap format1-inline ; inline
: rq-monitor     (                   -- request ) "MONITOR" format0 ; inline
: rq-move        ( key integer       -- request ) "MOVE" -rot format2-inline ; inline
: rq-ping        (                   -- request ) "PING" format0 ; inline
: rq-quit        (                   -- request ) "QUIT" format0 ; inline
: rq-randomkey   (                   -- request ) "RANDOMKEY" format0 ; inline
: rq-rename      ( key newkey        -- request ) "RENAME" -rot format2-inline ; inline
: rq-renamenx    ( key newkey        -- request ) "RENAMENX" -rot format2-inline ; inline
: rq-rpop        ( key               -- request ) "RPOP" swap format1-inline ; inline
: rq-rpush       ( value key         -- request ) "RPUSH" -rot format2-bulk ; inline
: rq-sadd        ( key member        -- request ) "SADD" -rot format2-bulk ; inline
: rq-save        (                   -- request ) "SAVE" format0 ; inline
: rq-scard       ( key               -- request ) "SCARD" swap format1-inline ; inline
: rq-select      ( integer           -- request ) "SELECT" swap format1-inline ; inline
: rq-set         ( key value         -- request ) "SET" -rot format2-bulk ; inline
: rq-setbit      ( key offset value  -- request ) [ "SETBIT" ] 3dip format3-inline ; inline
: rq-setnx       ( key value         -- request ) "SETNX" -rot format2-bulk ; inline
: rq-shutdown    (                   -- request ) "SHUTDOWN" format0 ; inline
: rq-sinter      ( keys              -- request ) "SINTER" swap format1-inline ; inline
: rq-sinterstore ( keys destkey      -- request ) "SINTERSTORE" -rot format2-inline ; inline
: rq-sismember   ( key member        -- request ) "SISMEMBER" -rot format2-bulk ; inline
: rq-smembers    ( key               -- request ) "SMEMBERS" swap format1-inline ; inline
: rq-smove       ( key newkey member -- request ) [ "SMOVE" ] 3dip format3-bulk ; inline
: rq-srem        ( key member        -- request ) "SREM" -rot format2-bulk ; inline
: rq-sunion      ( keys              -- request ) "SUNION" swap format1-inline ; inline
: rq-sunionstore ( keys destkey      -- request ) "SUNIONSTORE" -rot format2-inline ; inline
: rq-type        ( key               -- request ) "TYPE" swap format1-inline ; inline

<<
"jp.redis.formatter" vocab-words
[ drop 3 head "rq-" = ] assoc-filter
values [
    [
        name>> 3 cut-slice nip CHAR: \ prefix create-in
    ] keep [
        [
            stack-height 1 swap -
            [ scan-token suffix! ] times
        ] keep suffix!
    ] curry define-syntax
] each
>>
