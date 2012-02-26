! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.help.markup help.markup help.syntax om.help.markup quotations
       sequences ;
IN: om.combinatorial

HELP: sort-list
{ $values
  { "seq" sequence }
  { "&keys" { $keys } }
  { "seq'" sequence }
}
{ $description "Sorts a list."
  $nl
  { $snippet "test" } " is a binary function or function name indicating how to compare elements."
  $nl
  { $snippet "key" } " is a function or function name that will be applied to elements before the test."
  $nl
  "If " { $snippet "rec" } " is T, then the sort will be applied recursively to the sub-lists in " { $snippet "lst" } "." } ;

HELP: rotate
{ $values
  { "seq" sequence }
  { "&optionals" { $optionals } }
  { "seq'" sequence }
}
{ $description "Returns a circular permutation of " { $snippet "list" } " starting from its " { $snippet "nth" } " element." } ;

HELP: nth-random
{ $values
  { "seq" sequence }
  { "seq'" sequence }
}
{ $description "Returns a randomly chosen element from " { $snippet "list" } "." } ;

HELP: permut-random
{ $values
  { "seq" sequence }
  { "seq'" sequence }
}
{ $description "Returns a random permutation of " { $snippet "list" } "." } ;

HELP: posn-order
{ $values
  { "seq" sequence }
  { "fun" { $word/callable "( elt1 elt2 -- ? )" } }
  { "seq'" sequence }
}
{ $description "Returns a list of indices according to a sort function.  The indexes of items in " { $snippet "list" } " (from 0 to length-1) will be sorted according to " { $snippet "test" } "."
  $nl
  { $snippet "test" } " may be a function or function name (symbol) for a binary comparison function." } ;

HELP: permutations
{ $values
  { "seq" sequence }
  { "seq'" sequence }
}
{ $description "Return a list of all the permutations of " { $snippet "bag" } "." } ;

ARTICLE: "om.combinatorial" "om.combinatorial"
{ $vocab-intro "om.combinatorial" "projects/01-basicproject/functions/combinatorial.lisp" } ;

ABOUT: "om.combinatorial"
