! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: help.markup help.syntax kernel om.help.markup sequences ;
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

ARTICLE: "om.combinatorial" "om.combinatorial"
{ $vocab-intro "om.combinatorial" "projects/01-basicproject/functions/combinatorial.lisp" } ;

ABOUT: "om.combinatorial"
