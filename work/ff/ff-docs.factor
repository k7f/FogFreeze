! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: classes help.markup help.syntax kernel math quotations sequences ;
IN: ff

HELP: set-trace
{ $values
  { "level/?" "a " { $link fixnum } " or a " { $link boolean } }
}
{ $description "Turn tracing of verges on or off.  Optionally, specify tracing level." } ;

HELP: get-trace
{ $values
  { "level/?" "a " { $link fixnum } " or a " { $link boolean } }
}
{ $description "Get current level, or a flag, which controls tracing of verges." } ;

HELP: should-trace?
{ $values
  { "min-level" fixnum }
  { "?" boolean }
}
{ $description "Return false if tracing level is less than " { $snippet "min-level" } " or tracing is controlled by a flag.  Otherwise, return true." } ;
