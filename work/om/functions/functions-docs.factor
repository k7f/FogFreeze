! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: help.markup help.syntax kernel math om.help.markup quotations
       sequences ;
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

HELP: y-transfer
{ $values
  { "obj" object }
  { "y" number }
  { "&optionals" { $optionals } }
  { "x-values" "a " { $link sequence } " of " { $link number } "s" }
}
{ $description "Returns a list of interpolated X values corresponding to a list of points ((x1 y1) (x2 y2) ...), or a BPF/BPC (" { $snippet "self" } ") and a Y position " { $snippet "y0" } "."
$nl
"Optional " { $snippet "dec" } " is the number of decimals in the result." } ;

HELP: x-transfer
{ $values
  { "obj" object }
  { "x-values" "a " { $link number } " or a " { $link sequence } " of " { $link number } "s" }
  { "&optionals" { $optionals } }
  { "y-values" "a " { $link sequence } " of " { $link number } "s" }
}
{ $description "Returns the interpolated Y value(s) in a BPF or a list ((x1 y1) (x2 y2) ...) corresponding to an X value or a list of X values (" { $snippet "x-val" } ")."
$nl
"Optional " { $snippet "dec" } " is the number of decimals in the result." } ;

ARTICLE: "om.functions" "om.functions"
{ $vocab-intro "om.functions" "projects/01-basicproject/functions/functions.lisp" } ;

ABOUT: "om.functions"
