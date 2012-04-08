! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.help.markup arrays help.markup help.syntax math om.help.markup
       om.help.reference om.rhythm om.rhythm.transformer sequences ;
IN: om.trees

HELP: mktree
{ $values
  { "durs" { $sequence-of rational } }
  { "tsigs" { $class/sequence-of pair } }
  { "rtree" rhythm-tree }
}
{ $description "Builds a hierarchical " { $link rhythm-tree } " from a simple list of note values (" { $snippet "rhythm" } ").  1/4 is the quarter note."
  $nl
  { $snippet "timesigns" } " is a list of time signatures, e.g. " { $snippet "( (4 4) (3 4) (5 8) ... )" } ".  If a single time signature is given (e.g. " { $snippet "(4 4)" } "), it is extended as much as required by the 'rhythm' length."
  $nl
  "The output rhythm tree is intended for the " { $snippet "tree" } " input of a 'voice' factory box." } ;

HELP: reducetree
{ $values
  { "rhm" rhythm }
  { "relt" rhythm-element }
}
{ $description "Reduces and simplifies a tree by concatenating consecutive rests and floats." } ;

HELP: pulsemaker
{ $values
  { "nums" { $class/sequence-of number } }
  { "dens" { $class/sequence-of number } }
  { "pulses" { $sequence-of number } }
  { "rtree" rhythm-tree }
}
{ $description "Constructs a tree starting from a (list of) measure(s) numerator(s) " { $snippet "measures-num" } " and a (list of) denominator(s) " { $snippet "beat-unit" } " filling these measures with " { $snippet "npulses" } "." } ;

HELP: tietree
{ $values
  { "relt" rhythm-element }
  { "relt'" rhythm-element }
}
{ $description "Converts all rests in " { $snippet "tree" } " (a rhytm tree, VOICE or POLY object) into ties (i.e. float values in the RT)." } ;

HELP: transform-rests
{ $values
  { "rtf" rhythm-transformer }
  { "rtf'" rhythm-transformer }
}
{ $description "" } ;

HELP: remove-rests
{ $values
  { "relt" rhythm-element }
  { "relt'" rhythm-element }
}
{ $description "Converts all rests to notes." } ;

HELP: transform-notes-flt
{ $values
  { "rtf" rhythm-transformer }
  { "places" { $sequence-of integer } }
  { "rtf'" rhythm-transformer }
}
{ $description "" } ;

HELP: filtertree
{ $values
  { "relt" rhythm-element }
  { "places" { $sequence-of integer } }
  { "relt'" rhythm-element }
}
{ $description "Replaces expressed notes in given positions from " { $snippet "places" } " with rests." } ;

HELP: group-pulses
{ $values
  { "rhm" rhythm }
  { "pulses" { $sequence-of sequence } }
}
{ $description "Collects every pulses (expressed durations, including tied notes) from " { $snippet "tree" } "." } ;

HELP: n-pulses
{ $values
  { "rhm" rhythm }
  { "n" integer }
}
{ $description "Returns the numbre of pulses in " { $snippet "tree" } "." } ;

HELP: reversetree
{ $values
  { "rhm" rhythm }
  { "rhm'" rhythm }
}
{ $description "Recursively reverses " { $snippet "tree" } "." } ;

OM-REFERENCE:
"projects/02-musicproject/functions/trees.lisp"
{ "mktree" mktree }
{ "reducetree" reducetree }
{ "pulsemaker" pulsemaker }
{ "tietree" tietree }
{ "transform-rests" transform-rests }
{ "remove-rests" remove-rests }
{ "transform-notes-flt" transform-notes-flt }
{ "filtertree" filtertree }
{ "group-pulses" group-pulses }
{ "n-pulses" n-pulses }
{ "reversetree" reversetree } ;

ARTICLE: "om.trees" "om.trees"
{ $vocab-intro "om.trees" "projects/02-musicproject/functions/trees.lisp" } ;

ABOUT: "om.trees"
