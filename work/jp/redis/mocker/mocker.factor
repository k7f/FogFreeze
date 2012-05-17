! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: destructors io io.streams.duplex io.streams.plain kernel sequences ;
IN: jp.redis.mocker

SINGLETON: mock-address

<PRIVATE
SINGLETONS: (mock-reader) (mock-writer) ;
INSTANCE: (mock-reader) input-stream
INSTANCE: (mock-writer) output-stream
INSTANCE: (mock-writer) plain-writer

M: (mock-reader) dispose drop ;
M: (mock-reader) stream-element-type drop +byte+ ;
M: (mock-reader) stream-read1 drop f ;
M: (mock-reader) stream-read-unsafe 3drop 0 ;
M: (mock-reader) stream-read-partial-unsafe 3drop 0 ;

M: (mock-reader) stream-readln drop "#MOCKREPLY" ;
M: (mock-reader) stream-read-until
    drop [ CHAR: \n dup ] dip member-eq?
    [ "#MOCKREPLY" swap ] [ drop f f ] if ;

M: (mock-writer) dispose drop ;
M: (mock-writer) stream-element-type drop +byte+ ;
M: (mock-writer) stream-write1 2drop ;
M: (mock-writer) stream-write 2drop ;
M: (mock-writer) stream-flush drop ;
PRIVATE>

: with-mocker ( address encoding quot -- )
    [ drop (mock-reader) (mock-writer) ]
    [ <encoder-duplex> ] [ with-stream ] tri* ; inline
