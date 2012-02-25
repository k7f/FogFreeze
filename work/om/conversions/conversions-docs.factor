! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: help.markup help.syntax math om.help.markup sequences strings ;
IN: om.conversions

HELP: approx-m
{ $values
  { "midic" "a " { $link number } " or a " { $link sequence } " of " { $link number } "s" }
  { "approx" real }
  { "&optionals" { $optionals } }
  { "midic'" "a " { $link number } " or a " { $link sequence } " of " { $link number } "s" }
}
{ $optional-defaults
  { "ref-midic" "0" }
}
{ $description "Returns an approximation of " { $snippet "midic" } " (in midicents) to the nearest tempered division of the octave."
  $nl
  { $list
    { { $snippet "approx = 1" } " whole tones" }
    { { $snippet "approx = 2" } " semi tones" }
    { { $snippet "approx = 4" } " quarter tones" }
    { { $snippet "approx = 8" } " eight tones" }
  }
  $nl
  "Floating values are allowed for " { $snippet "approx" } "."
  $nl
  { $snippet "ref-midic" } " is a midicent that is subtracted from " { $snippet "midic" } " before computation: the computation can then be carried on an interval rather than an absolute pitch." } ;

HELP: mc->f
{ $values
  { "midic" "a " { $link number } " or a " { $link sequence } " of " { $link number } "s" }
  { "midic'" "a " { $link number } " or a " { $link sequence } " of " { $link number } "s" }
}
{ $description "Converts a (list of) midicent pitch(es) " { $snippet "midics" } " to frequencies (Hz)." } ;

HELP: f->mc
{ $values
  { "freq" "a " { $link number } " or a " { $link sequence } " of " { $link number } "s" }
  { "&optionals" { $optionals } }
  { "midic" "a " { $link number } " or a " { $link sequence } " of " { $link number } "s" }
}
{ $optional-defaults
  { "approx" "2" }
  { "ref-midic" "0" }
}
{ $description "Converts a frequency or list of frequencies to midicents."
  $nl
  "Approximation:"
  { $list
    { { $snippet "approx = 1" } " whole tones" }
    { { $snippet "approx = 2" } " semi tones" }
    { { $snippet "approx = 4" } " quarter tones" }
    { { $snippet "approx = 8" } " eight tones" }
  }
  $nl
  "Floating values are allowed for " { $snippet "approx" } "."
  $nl
  { $snippet "ref-midic" } " is a midicent that is subtracted from " { $snippet "midic" } " before computation: the computation can then be carried on an interval rather than an absolute pitch." } ;

HELP: +ascii-note-scales+
{ $var-description "The scales used by the functions " { $link mc->n } " and " { $link n->mc } "." } ;

HELP: mc->n1
{ $values
  { "midic" number }
  { "&optionals" { $optionals } }
  { "name" string }
}
{ $optional-defaults
  { "ascii-note-scale" "first element of " { $link +ascii-note-scales+ } }
}
{ $description "Converts " { $snippet "midic" } " to a string representing a symbolic ascii note." } ;

HELP: beats->ms
{ $values
  { "nbeats" real }
  { "tempo" real }
  { "duration" float }
}
{ $description "Converts a symbolic rhythmic beat division into the corresponding duration in milliseconds." } ;

ARTICLE: "om.conversions" "om.conversions"
{ $vocab-intro "om.conversions" "projects/02-musicproject/functions/conversions.lisp" } ;

ABOUT: "om.conversions"
