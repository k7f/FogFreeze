! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.help.markup arrays help.markup help.syntax math
       om.help.markup ;
IN: om.rhythm

HELP: rhythm-element
{ $var-description "" } ;

HELP: rhythm
{ $var-description "The slot " { $snippet "division" } " holds " { $sequence-of rhythm-element } "." } ;

HELP: onsets>rhythm
{ $values
  { "onsets" { $sequence-of number } }
  { "rhm" rhythm }
}
{ $description "" } ;

HELP: <rhythm>
{ $values
  { "onsets" { $sequence-of number } }
  { "total" number }
  { "rhm" rhythm }
}
{ $description "" } ;

HELP: <rhythm-element>
{ $values
  { "onsets" { $sequence-of number } }
  { "total" number }
  { "relt" rhythm-element }
}
{ $description "" } ;

HELP: fuse-rests-and-ties
{ $values
  { "relts" { $sequence-of rhythm-element } }
  { "relts'" { $sequence-of rhythm-element } }
}
{ $description "" } ;

HELP: meter
{ $var-description "This is a special kind of " { $link rhythm-duration } " serving as time signature of " { $link measure } "s." } ;

HELP: measure
{ $var-description "This is a special kind of " { $link rhythm } ", whose " { $snippet "duration" } " slot holds a " { $link meter } "." } ;

HELP: <measure>
{ $values
  { "onsets" { $sequence-of number } }
  { "num" number }
  { "den" number }
  { "measure" measure }
}
{ $description "Outputs a single " { $link measure } ", after having taken a sequence of absolute onset times followed by time signature's numerator and denominator.  The whole note is used as the time unit.  The measure starts at time " { $snippet "1" } ", ends at time " { $snippet "1+num/den" } "." } ;

HELP: zip-measures
{ $values
  { "durs" { $sequence-of rational } }
  { "tsigs" { $sequence-of pair } }
  { "rhm" rhythm }
}
{ $description "Takes a sequence of durations followed by a sequence of time signatures, and outputs a corresponding " { $link rhythm } ", which contains a sequence of " { $link measure } "s in the " { $snippet "division" } " slot." } ;

ARTICLE: "om.rhythm" "om.rhythm"
{ $aux-vocab-intro "om.rhythm" "om.trees" } ;

ABOUT: "om.rhythm"
