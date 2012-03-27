! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: help.markup help.syntax kernel math sequences ;
IN: addenda.sequences.iterators

HELP: rewind
{ $values
  { "iter" object }
}
{ $contract "" } ;

HELP: iterator
{ $var-description "" } ;

HELP: <iterator>
{ $values
  { "seq" sequence }
  { "iter" iterator }
}
{ $description "" } ;

HELP: >iterator<
{ $values
  { "iter" iterator }
  { "seq" sequence }
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

HELP: bi-iterator
{ $var-description "The length of a rewound " { $link bi-iterator } " equals the length of the second iterable." } ;

HELP: <bi-iterator>
{ $values
  { "seq1" sequence }
  { "seq2" sequence }
  { "iter" bi-iterator }
}
{ $description "" } ;

HELP: >bi-iterator<
{ $values
  { "iter" bi-iterator }
  { "seq1" sequence }
  { "seq2" sequence }
}
{ $description "" } ;

HELP: ?bi-peek
{ $values
  { "iter" bi-iterator }
  { "ndx" "a non-negative " { $link integer } }
  { "elt1/f" object }
  { "elt2/f" object }
}
{ $description "" } ;

HELP: ?bi-step
{ $values
  { "iter" bi-iterator }
  { "elt1/f" object }
  { "elt2/f" object }
}
{ $description "" } ;

HELP: bi-fold
{ $values
  { "iter" bi-iterator }
  { "identity" object }
  { "quot" { $quotation "( ..a prev elt1 elt2 -- ..b next )" } }
  { "result" object }
}
{ $description "" }
{ $notes "Execution of this word fails if an iterator's first iterable is shorter than the second." } ;

ARTICLE: "addenda.sequences.iterators" "addenda.sequences.iterators"
{ $vocab-link "addenda.sequences.iterators" } ;

ABOUT: "addenda.sequences.iterators"
