! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: help.markup help.syntax kernel sequences sequences.deep ;
IN: addenda.sequences.deep

HELP: deep-reduce
{ $values
  { "obj" object }
  { "identity" object }
  { "quot" { $quotation "( ..a prev elt -- ..b next )" } }
  { "result" object }
}
{ $description "Traverses nested elements of an object, in preorder, combines successively visited elements using a binary operation, and outputs the final result." }
{ $see-also reduce } ;

HELP: deep-filter-atoms
{ $values
  { "obj" object }
  { "quot" { $quotation "( ..a elt -- ..b ? )" } }
  { "seq" sequence }
}
{ $description "Like " { $link deep-filter } ", but operates only on non-branching elements of an object." } ;

HELP: deep-map-atoms
{ $values
  { "obj" object }
  { "quot" { $quotation "( ..a elt -- ..b elt' )" } }
  { "newobj" object }
}
{ $description "Like " { $link deep-map } ", but operates only on non-branching elements of an object." } ;

ARTICLE: "addenda.sequences.deep" "addenda.sequences.deep"
{ $vocab-link "addenda.sequences.deep" } ;

ABOUT: "addenda.sequences.deep"
