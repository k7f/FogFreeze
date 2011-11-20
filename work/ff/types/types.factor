! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: math quotations ;
IN: ff.types

MIXIN: ?fixnum
INSTANCE: f ?fixnum
INSTANCE: fixnum ?fixnum

MIXIN: ?callable
INSTANCE: f ?callable
INSTANCE: callable ?callable
