! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: help.markup help.syntax kernel om.help.markup sequences ;
IN: om.sets

HELP: x-union
{ $values
  { "seq1" sequence }
  { "seq2" sequence }
  { "&keys" { $keys } }
  { "&rest" { $rest } }
  { "seq'" sequence }
}
{ $description "Merges lists (" { $snippet "l1" } " and " { $snippet "l2" } " and possibly more) into a single list with no repetitions."
$nl
{ $snippet "test" } " is a function or function name for a binary comparison."
$nl
{ $snippet "key" } " is a name or function name to apply to the elements before comparison." } ;

HELP: x-intersect
{ $values
  { "seq1" sequence }
  { "seq2" sequence }
  { "&keys" { $keys } }
  { "&rest" { $rest } }
  { "seq'" sequence }
}
{ $description "Returns the intersection (i.e. common elements) from lists (" { $snippet "l1" } " and " { $snippet "l2" } " and possibly more) into a single list."
$nl
{ $snippet "test" } " is a function or function name for a binary comparison."
$nl
{ $snippet "key" } " is a name or function name to apply to the elements before comparison." } ;

HELP: x-diff
{ $values
  { "seq1" sequence }
  { "seq2" sequence }
  { "&keys" { $keys } }
  { "&rest" { $rest } }
  { "seq'" sequence }
}
{ $description "Returns the list of elements present in " { $snippet "l1" } " but not in " { $snippet "l2" } "."
$nl
{ $snippet "test" } " is a function or function name for a binary comparison."
$nl
{ $snippet "key" } " is a name or function name to apply to the elements before comparison." } ;

HELP: x-xor
{ $values
  { "seq1" sequence }
  { "seq2" sequence }
  { "&keys" { $keys } }
  { "&rest" { $rest } }
  { "seq'" sequence }
}
{ $description "XOR's lists (" { $snippet "l1" } " and " { $snippet "l2" } " and possibly more) into a single list.  XOR keeps only the elements present in one list and not in the other one(s)."
$nl
{ $snippet "test" } " is a function or function name for a binary comparison."
$nl
{ $snippet "key" } " is a name or function name to apply to the elements before comparison." } ;

HELP: included?
{ $values
  { "seq1" sequence }
  { "seq2" sequence }
  { "f/quot" { $quotation "( obj1 obj2 -- ? )" } " or " { $link POSTPONE: f } }
  { "?" boolean }
}
{ $description "Tests if " { $snippet "lst1" } " is included in " { $snippet "lst" } "."
$nl
{ $snippet "test" } " is a function or function name for a binary comparison." } ;

ARTICLE: "om.sets" "om.sets"
{ $vocab-intro "om.sets" "projects/01-basicproject/functions/sets.lisp" } ;

ABOUT: "om.sets"
