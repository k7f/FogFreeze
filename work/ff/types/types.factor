! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: math quotations ;
IN: ff.types

MIXIN: maybe-fixnum
INSTANCE: f maybe-fixnum
INSTANCE: fixnum maybe-fixnum

MIXIN: maybe-callable
INSTANCE: f maybe-callable
INSTANCE: callable maybe-callable
