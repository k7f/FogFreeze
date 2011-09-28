! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: classes help.markup help.syntax kernel quotations sequences ;
IN: verge

HELP: set-trace
{ $values
  { "?" boolean }
}
{ $description "Turn tracing of verges on or off." } ;

HELP: <verge-state>
{ $values
  { "start" object }
  { "slip" quotation }
  { "strains" sequence }
  { "state" "a " { $link verge-state } }
}
{ $description "Constructor of the " { $link verge-state } " class." }
{ $notes "Whenever it is important to guarantee, that the list of strains remains constant during a single verge, call " { $link clone } " before passing the strains (individual strains would still be allowed to change their state, however, as a result of side-effects)." } ;

HELP: verge
{ $values
  { "state" "a " { $link verge-state } }
  { "goal" quotation }
  { "step" quotation }
  { "hitstack" sequence }
  { "?" boolean }
}
{ $description "The result sequence is never empty, and its first element is always the value passed as " { $snippet "start" } " to " { $link <verge-state> } ".  If the result boolean is true, then the last element fulfills the goal." } ;

ARTICLE: "verge" "verge"
"The " { $vocab-link "verge" } " vocabulary deals with incremental searches in the space of sequences." ;

ABOUT: "verge"
