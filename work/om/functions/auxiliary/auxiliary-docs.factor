! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.help.markup classes help.markup help.syntax math om.help.markup
       om.help.reference sequences ;
IN: om.functions.auxiliary

HELP: x-around
{ $values
  { "x" number }
  { "points" "a " { $link sequence } " of pairs of " { $link number } "s" }
  { "result" "a two-element " { $link sequence } " of the same " { $link class } " as " { $snippet "points" } }
}
{ $description "If for all (xi yi) in " { $snippet "points" } " xi < x then outputs two copies of the last point."
  $nl
  "Otherwise, if for all (xi yi) in " { $snippet "points" } " xi >= x then outputs two copies of the first point."
  $nl
  "Otherwise, outputs two elements of " { $snippet "points" } ", (xi yi) and (xj yj), such that j = i + 1 and xi < x <= xj."
}
{ $notes "For any two elements of " { $snippet "points" } ", (xi yi) and (xj yj), it is assumed that if i < j then xi < xj." } ;

HELP: y-around
{ $values
  { "y" number }
  { "points" "a " { $link sequence } " of pairs of " { $link number } "s" }
  { "result" "a " { $link sequence } " of two-element " { $link sequence } "s of pairs of " { $link number } "s" }
}
{ $description "Outputs a sequence of all two-element subsequences of " { $snippet "points" } ", ((xi yi) (xj yj)), such that j = i + 1 and either yi <= y <= yj, or yi >= y >= yj." } ;

HELP: linear-interpol
{ $values
  { "x1" number }
  { "x2" number }
  { "y1" number }
  { "y2" number }
  { "x" number }
  { "y" number }
}
{ $description "Given an argument x, evaluates a linear function passing through the points (x1 y1) and (x2 y2)." }
{ $see-also linear-interpol* } ;

HELP: linear-interpol*
{ $values
  { "points" "a " { $link sequence } " of pairs of " { $link number } "s" }
  { "x" number }
  { "y" number }
}
{ $description "Given an argument x, evaluates a piecewise linear function passing through the " { $snippet "points" } "." }
{ $notes "Unlike " { $link linear-interpol } ", the function domain is limited to the range between x-coordinate of the first point, and the maximum of all x-coordinates.  For an argument from outside of the function domain, the output is 0." }
{ $see-also linear-interpol } ;

HELP: interpolate
{ $values
  { "xs" { $sequence-of number } }
  { "ys" { $sequence-of number } }
  { "step" number }
  { "result" number }
}
{ $description "" }
{ $see-also interpole } ;

HELP: interpole
{ $values
  { "xs" { $sequence-of number } }
  { "ys" { $sequence-of number } }
  { "x-min" number }
  { "x-max" number }
  { "n" "a non-negative " { $link integer } }
  { "result" number }
}
{ $description "" }
{ $see-also interpolate }
{ $warning "This version handles the left ray (half line) in the right way, i.e. in the same way as the right ray \u{em-dash} incompatibly." } ;

OM-REFERENCE:
"projects/01-basicproject/functions/functions.lisp"
{ "x-around" x-around }
{ "y-around" y-around }
{ "linear-interpol" linear-interpol }
{ "linear-interpol" linear-interpol* }
{ "interpolate" interpolate }
{ "interpole" interpole } ;

ARTICLE: "om.functions.auxiliary" "om.functions.auxiliary"
{ $aux-vocab-intro "om.functions" } ;

ABOUT: "om.functions.auxiliary"
