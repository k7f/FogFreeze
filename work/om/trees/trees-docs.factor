! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.help.markup arrays help.markup help.syntax math om.help.markup
       om.rhythm ;
IN: om.trees

HELP: mktree
{ $values
  { "durs" { $sequence-of rational } }
  { "tsigs" { $class/sequence-of pair } }
  { "rhm" rhythm }
}
{ $description "Builds a hierarchical rhythm tree from a simple list of note values (" { $snippet "rhythm" } ").  1/4 is the quarter note."
  $nl
  { $snippet "timesigns" } " is a list of time signatures, e.g. " { $snippet "( (4 4) (3 4) (5 8) ... )" } ".  If a single time signature is given (e.g. " { $snippet "(4 4)" } "), it is extended as much as required by the 'rhythm' length."
  $nl
  "The output rhythm tree is intended for the " { $snippet "tree" } " input of a 'voice' factory box." } ;

HELP: reducetree
{ $values
  { "rhm" rhythm }
  { "rhm'" rhythm }
}
{ $description "Reduces and simplifies a tree by concatenating consecutive rests and floats." } ;

HELP: pulsemaker
{ $values
  { "nums" { $class/sequence-of number } }
  { "dens" { $class/sequence-of number } }
  { "pulses" { $sequence-of number } }
  { "rhm" rhythm }
}
{ $description "Constructs a tree starting from a (list of) measure(s) numerator(s) " { $snippet "measures-num" } " and a (list of) denominator(s) " { $snippet "beat-unit" } " filling these measures with " { $snippet "npulses" } "." } ;

HELP: tietree
{ $values
  { "relt" rhythm-element }
  { "relt'" rhythm-element }
}
{ $description "Converts all rests in " { $snippet "tree" } " (a rhytm tree, VOICE or POLY object) into ties (i.e. float values in the RT)." } ;

ARTICLE: "om.trees" "om.trees"
{ $vocab-intro "om.trees" "projects/02-musicproject/functions/trees.lisp" } ;

ABOUT: "om.trees"
