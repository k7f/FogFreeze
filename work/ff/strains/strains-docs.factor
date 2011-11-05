! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: classes help.markup help.syntax kernel quotations sequences ff.verge
       words.symbol ;
IN: ff.strains

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

HELP: chain-in
{ $values
  { "strain" "a " { $link strain } }
  { "chain" "a " { $link sequence } " of " { $link strain } "s" }
  { "chain'" "a " { $link sequence } " of " { $link strain } "s" }
}
{ $description "Returns a copy of " { $snippet "chain" } ".  The copy is modified, if necessary, so that it will contain the " { $snippet "strain" } "." }
{ $notes "If the original " { $snippet "chain" } " contains an element having the same canonical class as the input " { $snippet "strain" } ", but a different value, that element will be replaced with the new one in the result." }
{ $errors "Throws an error if first input is not a " { $link strain } "." } ;

HELP: chain-in!
{ $values
  { "strain" "a " { $link strain } }
  { "chain" "a " { $link sequence } " of " { $link strain } "s" }
  { "chain" "a " { $link sequence } " of " { $link strain } "s" }
}
{ $description "Modifies " { $snippet "chain" } ", if necessary,  so that it will contain the " { $snippet "strain" } ".  If the " { $snippet "chain" } " contains an element having the same canonical class as the input " { $snippet "strain" } ", but a different value, that element will be replaced with the new one." }
{ $errors "Throws an error if first input is not a " { $link strain } ", or the " { $snippet "chain" } " is not resizable." } ;

HELP: chain-out
{ $values
  { "class" class }
  { "chain" "a " { $link sequence } " of " { $link strain } "s" }
  { "chain'" "a " { $link sequence } " of " { $link strain } "s" }
}
{ $description "Returns a copy of " { $snippet "chain" } " with those elements, which are instances of the " { $snippet "class" } ", removed from the result." }
{ $notes "This word, when passed a class which is not canonical, should be able to remove multiple elements from " { $snippet "chain" } ", but this feature is not yet supported." } ;

HELP: chain-out!
{ $values
  { "class" class }
  { "chain" "a " { $link sequence } " of " { $link strain } "s" }
  { "chain" "a " { $link sequence } " of " { $link strain } "s" }
}
{ $description "Modifies " { $snippet "chain" } ", if necessary, so that it will contain no elements of the " { $snippet "class" } "." }
{ $notes "This word, when passed a class which is not canonical, should be able to remove multiple elements from " { $snippet "chain" } ", but this feature is not yet supported." }
{ $errors "Throws an error if the " { $snippet "chain" } " is not resizable." } ;

{ chain-in chain-in! chain-out chain-out! } related-words

HELP: chain-reset!
{ $values
  { "chain" "a " { $link sequence } " of " { $link strain } "s" }
  { "chain" "a " { $link sequence } " of " { $link strain } "s" }
}
{ $description "Clears the chain, destructively." } ;

ARTICLE: "strains" "strains"
"The vocabulary " { $vocab-link "strains" } " defines the " { $link strain } " superclass and helps to maintain strain chains."
$nl
"Classes derived from " { $link strain } " are tuples on which feasibility checks, i.e. the checks performed during " { $link "verging" } ", are defined."
$nl
{ $emphasis "Strain chain" } " is a set of strains.  It may be any sequence of tuples (array, vector, etc.), provided the canonical classes of any two tuples in the sequence are " { $emphasis "different" } " subclasses of the " { $link strain } " class." ;

ABOUT: "strains"
