! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.help.markup addenda.sequences.deep help.markup help.syntax
       kernel quotations sequences sequences.deep ;
IN: addenda.sequences.deep.mono

HELP: fixed-deep-each
{ $values
  { "obj" object }
  { "quot" quotation }    
}
$ad-hoc-monomorphic
{ $see-also deep-each } ;

HELP: fixed-deep-filter
{ $values
  { "obj" object }
  { "quot" quotation }
  { "seq" sequence }
}
$ad-hoc-monomorphic
{ $see-also deep-filter } ;

HELP: fixed-deep-filter-atoms
{ $values
  { "obj" object }
  { "quot" quotation }
  { "seq" sequence }
}
$ad-hoc-monomorphic
{ $see-also deep-filter-atoms } ;

HELP: fixed-deep-reduce
{ $values
  { "obj" object }
  { "identity" object }
  { "quot" quotation }
  { "result" object }
}
$ad-hoc-monomorphic
{ $see-also deep-reduce } ;

ARTICLE: "addenda.sequences.deep.mono" "addenda.sequences.deep.mono"
"The " { $vocab-link "addenda.sequences.deep.mono" } " vocabulary contains non-polymorphic variants of words defined in " { $vocab-link "sequences.deep" } " and " { $vocab-link "addenda.sequences.deep" } " vocabularies.  Row polymorphic quotations are rejected by monomorphic combinators (i.e. the stack-depth effect has to be fixed)."
$ad-hoc-monomorphic ;

ABOUT: "addenda.sequences.deep.mono"
