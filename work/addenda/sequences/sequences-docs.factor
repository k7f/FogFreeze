! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: help.markup help.syntax kernel math quotations sequences
       sequences.deep ;
IN: addenda.sequences

HELP: ,:branch?
{ $values
  { "obj" object }
  { "?" boolean }
}
{ $description "Like " { $link branch? } ", but evaluates to " { $link POSTPONE: f } " for " { $link quotation } "s." } ;

HELP: sum-lengths-with-atoms
{ $values
  { "seq" sequence }
  { "n" integer }
}
{ $description "Like " { $link sum-lengths } ", but accepts atoms as valid elements of length 1, instead of raising an error." }
{ $see-also sum-lengths } ;

HELP: filter-as-index
{ $values
  { "seq" sequence }
  { "quot" { $quotation "( ..a elt ndx -- ..b ? )" } }
  { "exemplar" object }
  { "seq'" sequence }
}
{ $description "Index-dependent variant of " { $link filter-as } ", expecting a quotation which takes both, element " { $emphasis "and" } " its index, similarly to " { $link each-index } "." }
{ $see-also filter-index filter-as each-index } ;

HELP: filter-index
{ $values
  { "seq" sequence }
  { "quot" { $quotation "( ..a elt ndx -- ..b ? )" } }
  { "seq'" sequence }
}
{ $description "Index-dependent variant of " { $link filter } ", expecting a quotation which takes both, element " { $emphasis "and" } " its index, similarly to " { $link each-index } "." }
{ $see-also filter-as-index filter each-index } ;

HELP: filter-as/indices
{ $values
  { "seq" sequence }
  { "quot" { $quotation "( ..a elt -- ..b ? )" } }
  { "exemplar" object }
  { "seq'" sequence }
}
{ $description "Index-collecting variant of " { $link filter-as } ", which outputs a sequence of element indices, not the elements themselves." }
{ $see-also filter/indices filter-as } ;

HELP: filter/indices
{ $values
  { "seq" sequence }
  { "quot" { $quotation "( ..a elt -- ..b ? )" } }
  { "seq'" sequence }
}
{ $description "Index-collecting variant of " { $link filter } ", which outputs a sequence of element indices, not the elements themselves." }
{ $see-also filter-as/indices filter } ;

HELP: accumulate-all-as
{ $values
  { "seq" sequence }
  { "identity" object }
  { "quot" { $quotation "( ..a prev elt -- ..b next )" } }
  { "exemplar" object }
  { "newseq" sequence }
}
{ $description "Like " { $link accumulate-as } ", but stores all steps (including the final result) in the output sequence." }
{ $see-also accumulate-all accumulate-as } ;

HELP: accumulate-all
{ $values
  { "seq" sequence }
  { "identity" object }
  { "quot" { $quotation "( ..a prev elt -- ..b next )" } }
  { "newseq" sequence }
}
{ $description "Like " { $link accumulate } ", but stores all steps (including the final result) in the output sequence." }
{ $see-also accumulate-all-as accumulate } ;

HELP: find-tail
{ $values
  { "seq" sequence }
  { "candidates" sequence }
  { "tailseq/f" "a " { $link sequence } " or an " { $link f } }
}
{ $description "Outputs the tail of " { $snippet "seq" } " starting from the first " { $snippet "seq" } "'s element found in " { $snippet "candidates" } "." }
{ $see-also find-tail* } ;

HELP: find-tail*
{ $values
  { "seq" sequence }
  { "candidates" sequence }
  { "tailseq/f" "a " { $link sequence } " or an " { $link f } }
}
{ $description "Outputs the tail of " { $snippet "seq" } " starting from the first occurence of the first such element of " { $snippet "candidates" } ", that is also in " { $snippet "seq" } "." }
{ $see-also find-tail } ;

ARTICLE: "addenda.sequences" "addenda.sequences"
{ $vocab-link "addenda.sequences" } ;

ABOUT: "addenda.sequences"
