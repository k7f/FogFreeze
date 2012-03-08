! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: help.markup help.syntax kernel math quotations sequences
       sequences.deep ;
IN: addenda.sequences

HELP: atom?
{ $values
  { "obj" object }
  { "?" boolean }
}
{ $description "Like " { $link branch? } ", negated, but evaluates to " { $link POSTPONE: t } " for " { $link quotation } "s." } ;

HELP: sum-lengths-with-atoms
{ $values
  { "seq" sequence }
  { "n" integer }
}
{ $description "Like " { $link sum-lengths } ", but accepts atoms as valid elements of length 1, instead of raising an error." }
{ $see-also sum-lengths } ;

HELP: ?length
{ $values
  { "obj" object }
  { "n/f" { $maybe integer } }
}
{ $description "If " { $snippet "obj" } " is a sequence, then the output is its " { $link length } "; otherwise, the output is " { $link POSTPONE: f } "." } ;

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

HELP: 2filter-as
{ $values
  { "seq1" sequence }
  { "seq2" sequence }
  { "quot" { $quotation "( ..a elt1 elt2 -- ..b newelt ? )" } }
  { "exemplar" sequence }
  { "newseq" sequence }
}
{ $description "Applies the quotation to each pair of elements in turn, and outputs a new sequence of the same type as " { $snippet "exemplar" } ".  The quotation yields a new element and a boolean.  The new sequence contains those new elements returned by the quotation, for which the returned boolean is true." }
{ $see-also 2filter filter-as 2map-as } ;

HELP: 2filter
{ $values
  { "seq1" sequence }
  { "seq2" sequence }
  { "quot" { $quotation "( ..a elt1 elt2 -- ..b newelt ? )" } }
  { "newseq" sequence }
}
{ $description "Applies the quotation to each pair of elements in turn, and outputs a new sequence having the same class as " { $snippet "seq1" } ".  The quotation yields a new element and a boolean.  The new sequence contains those new elements returned by the quotation, for which the returned boolean is true." }
{ $see-also 2filter-as filter 2map } ;

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
  { "tailseq/f" { $maybe sequence } }
}
{ $description "Outputs the tail of " { $snippet "seq" } " starting from the first " { $snippet "seq" } "'s element found in " { $snippet "candidates" } "." }
{ $see-also find-tail* } ;

HELP: find-tail*
{ $values
  { "seq" sequence }
  { "candidates" sequence }
  { "tailseq/f" { $maybe sequence } }
}
{ $description "Outputs the tail of " { $snippet "seq" } " starting from the first occurence of the first such element of " { $snippet "candidates" } ", that is also in " { $snippet "seq" } "." }
{ $see-also find-tail } ;

HELP: trim-range-slice
{ $values
  { "seq" sequence }
  { "low" object }
  { "high" object }
  { "slice/f" { $maybe slice } }
}
{ $description "Removes elements of a sequence if they are before " { $snippet "low" } " or after " { $snippet "high" } " using an intrinsic total order." }
{ $notes "The elements of " { $snippet "seq" } " aren't assumed to be sorted (the implementation uses a simple linear algorithm).  The output is the minimal " { $link slice } " of the sequence such that no in-range element is left outside (unless there are no in-range elements, in which case the output is " { $link POSTPONE: f } ")." } ;

HELP: reduce-head
{ $values
  { "seq" sequence }
  { "identity" object }
  { "pred" { $quotation "( ... elt -- ... ? )" } }
  { "quot" { $quotation "( ... prev elt -- ... next )" } }
  { "newseq" sequence }
  { "result" object }
}
{ $description { $link trim-head } " and " { $link reduce } " combined.  Splits a sequence in two, beginning the second part at the first element which doesn't satisfy a predicate " { $snippet "pred" } ".  Outputs the second part followed by a reduction of the first part.  Uses a binary operation " { $snippet "quot" } " to perform the reduction." }
{ $see-also reduce-head-slice reduce-tail reduce-tail-slice } ;

HELP: reduce-head-slice
{ $values
  { "seq" sequence }
  { "identity" object }
  { "pred" { $quotation "( ... elt -- ... ? )" } }
  { "quot" { $quotation "( ... prev elt -- ... next )" } }
  { "slice" slice }
  { "result" object }
}
{ $description { $link trim-head-slice } " and " { $link reduce } " combined.  Splits a sequence in two, beginning the second part at the first element which doesn't satisfy a predicate " { $snippet "pred" } ".  Outputs a slice containing the second part followed by a reduction of the first part.  Uses a binary operation " { $snippet "quot" } " to perform the reduction." }
{ $see-also reduce-head reduce-tail reduce-tail-slice } ;

HELP: reduce-tail
{ $values
  { "seq" sequence }
  { "identity" object }
  { "pred" { $quotation "( ... elt -- ... ? )" } }
  { "quot" { $quotation "( ... prev elt -- ... next )" } }
  { "newseq" sequence }
  { "result" object }
}
{ $description { $link trim-tail } " and " { $link reduce } " combined.  Splits a sequence in two, ending the first part at the last element which doesn't satisfy a predicate " { $snippet "pred" } ".  Outputs the first part followed by a reduction of the second part.  Uses a binary operation " { $snippet "quot" } " to perform the reduction." }
{ $see-also reduce-tail-slice reduce-head reduce-head-slice } ;

HELP: reduce-tail-slice
{ $values
  { "seq" sequence }
  { "identity" object }
  { "pred" { $quotation "( ... elt -- ... ? )" } }
  { "quot" { $quotation "( ... prev elt -- ... next )" } }
  { "slice" slice }
  { "result" object }
}
{ $description { $link trim-tail-slice } " and " { $link reduce } " combined.  Splits a sequence in two, ending the first part at the last element which doesn't satisfy a predicate " { $snippet "pred" } ".  Outputs a slice containing the first part followed by a reduction of the second part.  Uses a binary operation " { $snippet "quot" } " to perform the reduction." }
{ $see-also reduce-tail reduce-head reduce-head-slice } ;

ARTICLE: "addenda.sequences" "addenda.sequences"
{ $vocab-link "addenda.sequences" } ;

ABOUT: "addenda.sequences"
