! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: help.markup help.syntax kernel math ;
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

ARTICLE: "addenda.math" "addenda.math"
{ $vocab-link "addenda.math" } ;

ABOUT: "addenda.math"
