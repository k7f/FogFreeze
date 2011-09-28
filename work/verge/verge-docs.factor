! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: classes help.markup help.syntax kernel math quotations sequences ;
IN: verge

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

HELP: <verge-state>
{ $values
  { "start" object }
  { "slip" quotation }
  { "strains" sequence }
  { "state" "a " { $link verge-state } }
}
{ $description "Constructor of the " { $link verge-state } " class." }
{ $notes "Whenever it is important to guarantee, that the list of strains remains constant during a single verge, call " { $link clone } " before passing the strains (individual strains would still be allowed to change their state, however, as a result of side-effects)." } ;

HELP: (verge)
{ $values
  { "state" "a " { $link verge-state } }
  { "goal" quotation }
  { "step" quotation }
  { "hitlist" sequence }
  { "?" boolean }
}
{ $description "The result sequence is never empty, and its first element is always the value passed as " { $snippet "start" } " to " { $link <verge-state> } ".  If the result boolean is true, then the last element fulfills the goal." } ;

HELP: verge
{ $values
  { "start" object }
  { "first-slip-maker" quotation }
  { "next-slip-maker" quotation }
  { "strains" sequence }
  { "goal" quotation }
  { "step" quotation }
  { "hitlist" sequence }
  { "?" boolean }
}
{ $description "The result sequence is never empty, and its first element is always " { $snippet "start" } ".  If the result boolean is true, then the last element fulfills the goal." } ;

ARTICLE: "verge" "verge"
"The " { $vocab-link "verge" } " vocabulary deals with incremental searches in the space of sequences."
$nl
"Backtracking is implemented in a lightweight (hopefully...) way, by using two dedicated stacks, instead of full-blown continuations." ;

ABOUT: "verge"
