! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: help.markup help.syntax kernel math sequences ;
IN: addenda.sequences.iterators

HELP: iterator
{ $var-description "" } ;

HELP: <iterator>
{ $values
  { "seq" sequence }
  { "iter" iterator }
}
{ $description "" } ;

HELP: rewind
{ $values
  { "iter" iterator }
}
{ $description "" } ;

HELP: ?peek
{ $values
  { "iter" iterator }
  { "ndx" "a non-negative " { $link integer } }
  { "elt/f" object }
}
{ $description "" } ;

HELP: ?step
{ $values
  { "iter" iterator }
  { "elt/f" object }
}
{ $description "" } ;

HELP: fold
{ $values
  { "iter" iterator }
  { "quot" { $quotation "( ..a prev elt -- ..b next )" } }
  { "result" object }
}
{ $description "" } ;

ARTICLE: "addenda.sequences.iterators" "addenda.sequences.iterators"
{ $vocab-link "addenda.sequences.iterators" } ;

ABOUT: "addenda.sequences.iterators"
