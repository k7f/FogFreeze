! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: help.markup help.syntax kernel sequences ;
IN: addenda.sequences

HELP: filter-as-index
{ $values
  { "seq" sequence }
  { "quot" { $quotation "( ..a elt ndx -- ..b ? )" } }
  { "exemplar" object }
  { "seq'" sequence }
}
{ $description "Like " { $link filter-as } ", but the quotation takes both, element " { $emphasis "and" } " its index, similarly to " { $link each-index } "." } ;

HELP: filter-index
{ $values
  { "seq" sequence }
  { "quot" { $quotation "( ..a elt ndx -- ..b ? )" } }
  { "seq'" sequence }
}
{ $description "Like " { $link filter } ", but the quotation takes both, element " { $emphasis "and" } " its index, similarly to " { $link each-index } "." } ;

HELP: filter-as/indices
{ $values
  { "seq" sequence }
  { "quot" { $quotation "( ..a elt -- ..b ? )" } }
  { "exemplar" object }
  { "seq'" sequence }
}
{ $description "Like " { $link filter-as } ", but outputs a sequence of element indices, not the elements themselves." } ;

HELP: filter/indices
{ $values
  { "seq" sequence }
  { "quot" { $quotation "( ..a elt -- ..b ? )" } }
  { "seq'" sequence }
}
{ $description "Like " { $link filter } ", but outputs a sequence of element indices, not the elements themselves." } ;

ARTICLE: "addenda.sequences" "addenda.sequences"
{ $vocab-link "addenda.sequences" } ;

ABOUT: "addenda.sequences"
