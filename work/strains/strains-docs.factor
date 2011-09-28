! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: classes help.markup help.syntax kernel quotations sequences words.symbol ;
IN: strains

HELP: strain
{ $class-description "The base class of all strains." } ;

HELP: check
{ $values
  { "state" sequence }
  { "value" object }
  { "strain" "a " { $link strain } }
  { "state" sequence }
  { "value" object }
  { "strain/f" { $maybe strain } }
}
{ $contract "Classes derived from strain should invoke call-next-method instead of throw." }
{ $errors "Throws an error on failure." } ;

HELP: strain=
{ $values
  { "strain1" "a " { $link strain } }
  { "strain2" "a " { $link strain } }
  { "?" boolean }
}
{ $contract "Outputs true if two strains are equivalent, otherwise outputs false." } ;

HELP: set-strain
{ $values
  { "chain" { $link symbol } " id of a variable holding strain sequence" }
  { "strain/f" { $maybe strain } }
  { "class" class }
}
{ $description "Inserts, modifies or removes from the chain a strain of the particular strain subclass." } ;

HELP: reset-chain
{ $values
  { "chain" { $link symbol } " id of a variable holding strain sequence" }
}
{ $description "Clears the chain." } ;

ARTICLE: "strains" "strains"
"The vocabulary " { $vocab-link "strains" } " maintains strain chains."
$nl
{ $emphasis "Strain chain" } " is any sequence (array, vector, etc.) of tuples, where the classes of any two tuples in the sequence are different subclasses of the " { $link strain } " class." ;

ABOUT: "strains"
