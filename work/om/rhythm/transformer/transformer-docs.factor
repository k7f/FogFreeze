! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.help.markup help.markup help.syntax math om.help.markup
       om.help.reference om.rhythm ;
IN: om.rhythm.transformer

HELP: rhythm-ref
{ $var-description "A reference to an atomic " { $link rhythm-element } "." } ;

HELP: <rhythm-ref>
{ $values
  { "ndx" integer }
  { "parent" rhythm }
  { "value/f" { $maybe integer } }
  { "ref" rhythm-ref }
}
{ $description "Creates a new " { $link rhythm-ref } ". Missing numeric " { $snippet "value" } " is supplied from the current element at " { $snippet "ndx" } ". The " { $snippet "parent" } " is never modified, even if numeric " { $snippet "value" } " is specified." } ;

HELP: >rhythm-ref<
{ $values
  { "ref" rhythm-ref }
  { "ndx" integer }
  { "parent/f" { $maybe rhythm } }
  { "value" integer }
}
{ $description "Outputs the current values of a " { $link rhythm-ref } "'s slots.  If " { $snippet "parent" } " " { $link rhythm } " is valid, the element referred to is updated." }
{ $see-also !rhythm-ref } ;

HELP: !rhythm-ref
{ $values
  { "ref" rhythm-ref }
}
{ $description "Updates the element referred to by a " { $link rhythm-ref } " without outputing slot values." }
{ $see-also >rhythm-ref< } ;

HELP: rhythm-transformer
{ $var-description "The slot " { $snippet "refs" } " is a flat " { $sequence-of rhythm-ref } ". This is a subsequence of atomic " { $link rhythm-element } "s contained in the " { $snippet "underlying" } " " { $link rhythm } "." } ;

HELP: <rhythm-transformer>
{ $values
  { "rhm" rhythm }
  { "rt" rhythm-transformer }
}
{ $description "Creates a new " { $link rhythm-transformer } " containing " { $link rhythm-ref } "s to all atomic " { $link rhythm-element } "s of " { $snippet "rhm" } "." }
{ $see-also <rhythm-transformer*> } ;

HELP: <rhythm-transformer*>
{ $values
  { "rhm" rhythm }
  { "pred" { $quotation "( ... value -- ... ? )" } }
  { "rt" rhythm-transformer }
}
{ $description "Creates a new " { $link rhythm-transformer } " containing " { $link rhythm-ref } "s to all atomic " { $link rhythm-element } "s of " { $snippet "rhm" } "."
  $nl
  "Indexing of references is controlled by the predicate, which takes a numeric value of an atomic element and outputs a boolean indicating whether to increment the index for that atom." }
{ $see-also <rhythm-transformer> } ;

HELP: >rhythm-transformer<
{ $values
  { "rt" rhythm-transformer }
  { "rhm" rhythm }
}
{ $description "Outputs the underlying " { $link rhythm } " of a " { $link rhythm-transformer } " after updating " { $link rhythm-element } "s referred to by all valid " { $link rhythm-ref } "s." } ;

HELP: with-rhythm-transformer
{ $values
  { "rhm" rhythm }
  { "quot" { $quotation "( ... refs -- ... refs' )" } }
  { "rhm'" rhythm }
}
{ $description "Modifies a " { $link rhythm } ". Constructs a temporary " { $link rhythm-transformer } ",  passes it through a quotation as " { $sequence-of rhythm-ref } ", and updates all " { $link rhythm-element } "s referred to by valid " { $link rhythm-ref } "s returned by the quotation." }
{ $see-also with-rhythm-transformer* } ;

HELP: with-rhythm-transformer*
{ $values
  { "rhm" rhythm }
  { "pred" { $quotation "( ... value -- ... ? )" } }
  { "quot" { $quotation "( ... refs -- ... refs' )" } }
  { "rhm'" rhythm }
}
{ $description "Modifies a " { $link rhythm } ". Constructs a temporary " { $link rhythm-transformer } ",  passes it through a quotation as " { $sequence-of rhythm-ref } ", and updates all " { $link rhythm-element } "s referred to by valid " { $link rhythm-ref } "s returned by the quotation."
  $nl  
  "Indexing of references is controlled by the predicate, which takes a numeric value of an atomic element and outputs a boolean indicating whether to increment the index for that atom." }
{ $see-also with-rhythm-transformer } ;

OM-REFERENCE:
"projects/02-musicproject/functions/trees.lisp"
{ "treeobj" rhythm-ref "type" }
{ "trans-tree" <rhythm-transformer> }
{ "trans-obj" >rhythm-transformer< } ;

ARTICLE: "om.rhythm.transformer" "om.rhythm.transformer"
{ $aux-vocab-intro "om.rhythm.transformer" "om.trees" } ;

ABOUT: "om.rhythm.transformer"
