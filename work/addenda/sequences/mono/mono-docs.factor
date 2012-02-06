! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.help.markup addenda.sequences help.markup help.syntax kernel
       math quotations sequences ;
IN: addenda.sequences.mono

HELP: fixed-any?
{ $values
  { "seq" sequence }
  { "quot" quotation }
  { "?" boolean }
}
$ad-hoc-monomorphic
{ $see-also any? } ;

HELP: fixed-filter
{ $values
  { "seq" sequence }
  { "quot" quotation }
  { "seq'" sequence }
}
$ad-hoc-monomorphic
{ $see-also filter } ;

HELP: fixed-filter-as
{ $values
  { "seq" sequence }
  { "quot" quotation }
  { "exemplar" object }
  { "seq'" sequence }
}
$ad-hoc-monomorphic 
{ $see-also filter-as } ;

HELP: fixed-filter-as/indices
{ $values
  { "seq" sequence }
  { "quot" quotation }
  { "exemplar" object }
  { "seq'" sequence }
}
$ad-hoc-monomorphic
{ $see-also filter-as/indices } ;

HELP: fixed-filter/indices
{ $values
  { "seq" sequence }
  { "quot" quotation }
  { "seq'" sequence }
}
$ad-hoc-monomorphic
{ $see-also filter/indices } ;

HELP: fixed-find
{ $values
  { "seq" sequence }
  { "quot" quotation }
  { "i" object }
  { "elt" object }
}
$ad-hoc-monomorphic
{ $see-also find } ;

HELP: fixed1-each-integer
{ $values
  { "a" object }
  { "n" object }
  { "quot" quotation }
  { "a'" object }
}
$ad-hoc-monomorphic
{ $see-also each-integer } ;

HELP: fixed1-filter-as-index
{ $values
  { "a" object }
  { "seq" sequence }
  { "quot" quotation }
  { "exemplar" object }
  { "b" object }
  { "seq'" sequence }
}
$ad-hoc-monomorphic
{ $see-also filter-as-index } ;

HELP: fixed1-filter-index
{ $values
  { "a" object }
  { "seq" sequence }
  { "quot" quotation }
  { "b" object }
  { "seq'" sequence }
}
$ad-hoc-monomorphic
{ $see-also filter-index } ;

HELP: fixed1-times
{ $values
  { "a" object }
  { "n" object }
  { "quot" quotation }
  { "a'" object }
}
$ad-hoc-monomorphic
{ $see-also times } ;

HELP: fixed2-each-integer
{ $values
  { "a" object }
  { "b" object }
  { "n" object }
  { "quot" quotation }
  { "a'" object }
  { "b'" object }
}
$ad-hoc-monomorphic
{ $see-also each-integer } ;

HELP: fixed2-times
{ $values
  { "a" object }
  { "b" object }
  { "n" object }
  { "quot" quotation }
  { "a'" object }
  { "b'" object }
}
$ad-hoc-monomorphic
{ $see-also times } ;

HELP: fixed3-map!
{ $values
  { "a" object }
  { "b" object }
  { "c" object }
  { "seq" sequence }
  { "quot" quotation }    
}
$ad-hoc-monomorphic
{ $see-also map! } ;

ARTICLE: "addenda.sequences.mono" "addenda.sequences.mono"
"The " { $vocab-link "addenda.sequences.mono" } " vocabulary contains non-polymorphic variants of words defined in " { $vocab-link "sequences" } " and " { $vocab-link "addenda.sequences" } " vocabularies.  Row polymorphic quotations are rejected by monomorphic combinators (i.e. the stack-depth effect has to be fixed)."
$ad-hoc-monomorphic ;

ABOUT: "addenda.sequences.mono"
