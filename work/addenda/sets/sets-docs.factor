! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: help.markup help.syntax kernel om.help.markup quotations sequences
       sets ;
IN: addenda.sets

HELP: members*
{ $values
  { "seq" sequence }
  { "quot" { $quotation "( obj1 obj2 -- ? )" } }
  { "seq'" sequence }
}
{ $description { $set-combinator members } }
{ $see-also members "lisp-alikes" } ;

HELP: set-like*
{ $values
  { "seq" sequence }
  { "quot" { $quotation "( obj1 obj2 -- ? )" } }
  { "exemplar" set }
  { "set" set }
}
{ $description { $set-combinator set-like } } ;

HELP: union*
{ $values
  { "seq1" sequence }
  { "seq2" sequence }
  { "quot" { $quotation "( obj1 obj2 -- ? )" } }
  { "seq'" sequence }
}
{ $description { $set-combinator union } }
{ $see-also union "lisp-alikes" } ;

HELP: intersect*
{ $values
  { "seq1" sequence }
  { "seq2" sequence }
  { "quot" { $quotation "( obj1 obj2 -- ? )" } }
  { "seq'" sequence }
}
{ $description { $set-combinator intersect } }
{ $see-also intersect "lisp-alikes" } ;

HELP: diff*
{ $values
  { "seq1" sequence }
  { "seq2" sequence }
  { "quot" { $quotation "( obj1 obj2 -- ? )" } }
  { "seq'" sequence }
}
{ $description { $set-combinator diff } }
{ $see-also diff "lisp-alikes" } ;

HELP: symmetric-diff
{ $values
  { "set1" set }
  { "set2" set }
  { "set'" set }
}
{ $description "Outputs a set consisting of elements present in exactly one of the two input sets, " { $snippet "set1" } " and " { $snippet "set2" } ", comparing elements for equality."
$nl
"This word has a default definition which works for all sets, but set implementations may override the default for efficiency."
}
{ $examples
  { $example "USING: om.support prettyprint ;" "{ 1 2 3 } { 2 3 4 } symmetric-diff ."
    "{ 1 4 }" }
} ;

HELP: symmetric-diff*
{ $values
  { "seq1" sequence }
  { "seq2" sequence }
  { "quot" { $quotation "( obj1 obj2 -- ? )" } }
  { "seq'" sequence }
}
{ $description { $set-combinator symmetric-diff } }
{ $see-also symmetric-diff "lisp-alikes" } ;

HELP: subset*?
{ $values
  { "seq1" sequence }
  { "seq2" sequence }
  { "quot" { $quotation "( obj1 obj2 -- ? )" } }
  { "?" boolean }
}
{ $description { $set-combinator subset? } }
{ $see-also subset? "lisp-alikes" } ;

ARTICLE: "addenda.sets" "addenda.sets"
{ $vocab-link "addenda.sets" } ;

ABOUT: "addenda.sets"
