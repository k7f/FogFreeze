! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.help.markup arrays help.markup help.syntax kernel math
       om.help.markup om.help.reference sequences words.symbol ;
IN: om.lists

HELP: last-elem
{ $values
  { "seq" sequence }
  { "obj/f" object }
}
{ $description "Returns the last element of " { $snippet "list" } "." } ;

HELP: last-n
{ $values
  { "seq" sequence }
  { "n" "a non-negative " { $link integer } }
  { "seq'" sequence }
}
{ $description "Returns the " { $snippet "n" } " last elements of " { $snippet "list" } "." } ;

HELP: first-n
{ $values
  { "seq" sequence }
  { "n" "a non-negative " { $link integer } }
  { "seq'" sequence }
}
{ $description "Returns the " { $snippet "n" } " first elements of " { $snippet "list" } "." } ;

HELP: x-append
{ $values
  { "obj1" object }
  { "obj2" object }
  { "&rest" object }
  { "seq" sequence }
}
{ $description "Appends lists or atoms together to form a new list." }
{ $notes "This function also works with additional elements." } ;

HELP: flat
{ $values
  { "seq" sequence }
  { "&optionals" { $optionals } }
  { "seq'" sequence }
}
{ $optional-defaults
  { "level" { $link f } }
}
{ $description "Transforms a tree-list (i.e. a list of lists) into a flat list."
  $nl
  "If " { $snippet "level" } " is 1 (resp n) remove 1 (resp. n) level(s) of list imbrication."
  $nl
  "If " { $snippet "level" } " is NIL (default) remove all levels of imbrication, down to a purely flat list." } ;

HELP: create-list
{ $values
  { "n" "a non-negative " { $link integer } }
  { "obj" object }
  { "seq" sequence }
}
{ $description "Returns a list of length " { $snippet "count" } " filled with repetitions of element " { $snippet "elem" } "." } ;

HELP: mat-trans
{ $values
  { "mat" sequence }
  { "mat'" sequence }
}
{ $description "Matrix transposition."
  $nl
  "The matrix is represented by a list of rows. Each row is a list of items. Rows and columns are interchanged." } ;

HELP: expand-lst
{ $values
  { "obj" object }
  { "seq" sequence }
}
{ $description "Expands a list following repetition patterns."
  $nl
  "1. <number>* (x1\u{horizontal-ellipsis}x2)\n"
  "repeats the pattern x1\u{horizontal-ellipsis}x2 <number> times."
  $nl
  "2. <n>_<m>s<k>\n"
  "appends an arithmetic series counting from <n> to <m> by step <k>.\n"
"s<k> can be omitted (k=1)." } ;

HELP: group-list
{ $values
  { "seq" sequence }
  { "segmentation" "a non-negative " { $link integer } " or a " { $link sequence } }
  { "mode" symbol }
  { "seq'" sequence }
}
{ $description "Segments a " { $snippet "list" } " in successives sublists which lengths are successive values of the list " { $snippet "segmentation" } "." }
{ $notes { $snippet "mode" } " indicates if " { $snippet "list" } " is to be read in a circular way." } ;

HELP: remove-dup
{ $values
  { "seq" sequence }
  { "test-fun" { $word/callable "( obj1 obj2 -- ? )" } }
  { "depth" fixnum }
  { "seq'" sequence }
}
{ $description "Removes duplicates elements from " { $snippet "list" } "."
  $nl
  "If " { $snippet "depth" } " is more than 1 duplicates are removed from sublists of level " { $snippet "depth" } "." } ;

HELP: list-modulo
{ $values
  { "seq" sequence }
  { "n" "a non-negative " { $link integer } }
  { "arr" array }
}
{ $description "Groups the elements of a list distant of a regular interval " { $snippet "ncol" } " and returns these groups as a list of lists." } ;

HELP: interlock
{ $values
  { "seq-to" sequence }
  { "seq-from" sequence }
  { "seq-where" sequence }
  { "result" sequence }
}
{ $description "Inserts the successive elements of " { $snippet "lis2" } " in " { $snippet "lis1" } " before the elements of " { $snippet "lis1" } " of respective positions from " { $snippet "plc1" } "." } ;

HELP: subs-posn
{ $values
  { "seq" sequence }
  { "posn" object }
  { "subs" object }
  { "seq" sequence }
}
{ $description "Substitutes the elements of " { $snippet "lis1" } " at position(s) " { $snippet "posn" } " (if they exist) with the corresponding elements in " { $snippet "val" } "." } ;

OM-REFERENCE:
"projects/01-basicproject/functions/lists.lisp"
{ "last-elem" last-elem }
{ "last-n" last-n }
{ "first-n" first-n }
{ "x-append" x-append }
{ "flat" flat }
{ "create-list" create-list }
{ "mat-trans" mat-trans }
{ "expand-lst" expand-lst }
{ "group-list" group-list }
{ "remove-dup" remove-dup }
{ "list-modulo" list-modulo }
{ "interlock" interlock }
{ "subs-posn" subs-posn } ;

ARTICLE: "om.lists" "om.lists"
{ $vocab-intro "om.lists" "projects/01-basicproject/functions/lists.lisp" } ;

ABOUT: "om.lists"
