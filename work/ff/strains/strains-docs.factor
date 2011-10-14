! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: classes help.markup help.syntax kernel quotations sequences verge words.symbol ;
IN: strains

HELP: strain
{ $class-description "The base class of all strains." } ;

HELP: check
{ $values
  { "state" sequence }
  { "new-value" object }
  { "strain" "a " { $link strain } }
  { "state" sequence }
  { "new-value" object }
  { "strain/f" { $maybe strain } }
}
{ $contract "The three possible outcomes of calling " { $link check } " are soft failure, hard failure and success.  Soft failure is indicated by retaining the " { $link strain } " object at the top of the stack.  Hard failure happens when the word throws the input " { $link strain } " object as an error.  The return value of " { $link f } " indicates a success."
  $nl
  "The only change this word is allowed to make is to the top of the stack.  " }
{ $notes "Classes derived from " { $link strain } " should never distinguish between soft and hard failure by themselves.  Instead, when failing, they should invoke " { $link POSTPONE: call-next-method } " \u{em-dash} which will perform the necessary bookkeeping, and decide whether to throw or not." }
{ $errors "Throws an error in case of hard failure." } ;

HELP: strain=
{ $values
  { "strain1" "a " { $link strain } }
  { "strain2" "a " { $link strain } }
  { "?" boolean }
}
{ $contract "Outputs " { $link t } " if two strains are equivalent, otherwise outputs " { $link f } "." } ;

HELP: set-strain
{ $values
  { "chain" { $link symbol } " id of a variable holding a strain set" }
  { "strain/f" { $maybe strain } }
  { "class" class }
}
{ $description "Inserts, modifies or removes an object of a particular " { $snippet "class" } " from the " { $snippet "chain" } ".  The " { $snippet "class" } " is expected to be a subclass of " { $link strain } "." } ;

HELP: reset-chain
{ $values
  { "chain" { $link symbol } " id of a variable holding a strain set" }
}
{ $description "Clears the chain." } ;

ARTICLE: "strains" "strains"
"The vocabulary " { $vocab-link "strains" } " defines the " { $link strain } " superclass and helps to maintain strain chains."
$nl
"Classes derived from " { $link strain } " are tuples on which feasibility checks (i.e. the checks performed during " { $link "verging" } ") are defined."
$nl
{ $emphasis "Strain chain" } " is a set of strains.  It may be any sequence of tuples (array, vector, etc.), provided the classes of any two tuples in the sequence are different subclasses of the " { $link strain } " class." ;

ABOUT: "strains"
