! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: classes help.markup help.syntax math om.help.markup sequences ;
IN: om.functions.auxiliary

HELP: x-around
{ $values
  { "x" number }
  { "pairs" "a " { $link sequence } " of pairs of " { $link number } "s" }
  { "result" "a two-element " { $link sequence } " of the same " { $link class } " as " { $snippet "pairs" } }
}
{ $description "If for all (xi yi) in " { $snippet "pairs" } " xi < x then outputs two copies of the last pair."
$nl
"Otherwise, if for all (xi yi) in " { $snippet "pairs" } " xi >= x then outputs two copies of the first pair."
$nl
"Otherwise, outputs two elements of " { $snippet "pairs" } ", (xi yi) and (xj yj), such that j = i + 1 and xi < x <= xj." }
{ $notes "For any two elements of " { $snippet "pairs" } ", (xi yi) and (xj yj), it is assumed that if i < j then xi < xj." } ;

HELP: y-around
{ $values
  { "y" number }
  { "pairs" "a " { $link sequence } " of pairs of " { $link number } "s" }
  { "result" "a " { $link sequence } " of two-element " { $link sequence } "s of pairs of " { $link number } "s" }
}
{ $description "Outputs a sequence of all two-element subsequences of " { $snippet "pairs" } ", ((xi yi) (xj yj)), such that j = i + 1 and either yi <= y <= yj, or yi >= y >= yj." } ;

HELP: linear-interpol
{ $values
  { "x1" number }
  { "x2" number }
  { "y1" number }
  { "y2" number }
  { "x" number }
  { "y" number }
}
{ $description "Given an argument x, evaluates a linear function passing through the points (x1 y1) and (x2 y2)." } ;

ARTICLE: "om.functions.auxiliary" "om.functions.auxiliary"
{ $aux-vocab-intro "om.functions" } ;

ABOUT: "om.functions.auxiliary"
