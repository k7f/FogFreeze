! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: help.markup help.syntax kernel math om.help.markup quotations ;
IN: om.functions

HELP: linear-fun
{ $values
  { "x0" number }
  { "y0" number }
  { "x1" number }
  { "y1" number }
  { "quot" { $quotation "( x -- y )" } }
}
{ $description "Constructs a linear function passing through the points (x0 y0) and (x1 y1)."
$nl
"The resulting function can be connected for example to SAMPLEFUN." }
{ $notes "In a special case of x0 being equal x1, the output function's values are all 0 except at point x0, where the function evaluates to 1." } ;

ARTICLE: "om.functions" "om.functions"
{ $vocab-intro "om.functions" "projects/01-basicproject/functions/functions.lisp" } ;

ABOUT: "om.functions"
