! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.help.markup help.markup help.syntax kernel math sequences ;
IN: addenda.math

HELP: nonnegative-integer!
{ $values
  { "obj" object }
  { "num/*" "a non-negative " { $link integer } " (after successful execution)" }
}
{ $description "Assertion word." } ;

HELP: >power-of-2
{ $values
  { "m" "a non-negative " { $link integer } }
  { "n" integer }
}
{ $description "Like " { $link next-power-of-2 } ", but rounding down, not up." } ;

HELP: >rational
{ $values
  { "obj" object }
  { "rat" rational }
}
{ $description "Converts the input to a rational number.  The set of convertible types contains at least numbers and non-empty sequences of convertibles.  The currently defined set of convertible types contains, additionally: " { $convertibles >rational { number sequence } "no additional types" } "." } ;

ARTICLE: "addenda.math" "addenda.math"
{ $vocab-link "addenda.math" } ;

ABOUT: "addenda.math"
