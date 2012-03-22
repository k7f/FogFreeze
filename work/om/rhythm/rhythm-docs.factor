! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.help.markup arrays help.markup help.syntax kernel math
       om.help.markup om.help.reference om.rhythm.meter om.rhythm.private
       sequences ;
IN: om.rhythm

HELP: rhythm-duration
{ $var-description "" } ;

HELP: rhythm-element
{ $var-description "" } ;

HELP: rhythm
{ $var-description "The slot " { $snippet "division" } " holds " { $sequence-of rhythm-element } "." } ;

HELP: >rhythm-duration
{ $values
  { "obj" object }
  { "dur" rhythm-duration }
}
{ $description "" } ;

HELP: >rhythm-element
{ $values
  { "obj" object }
  { "relt" rhythm-element }
}
{ $description "" } ;

HELP: <rhythm>
{ $values
  { "dur" object }
  { "dvn" sequence }
  { "rtm" rhythm }
}
{ $description "" } ;

HELP: onsets>rhythm
{ $values
  { "onsets" { $sequence-of number } }
  { "rhm" rhythm }
}
{ $description "" } ;

HELP: absolute-rhythm
{ $values
  { "onsets" { $sequence-of number } }
  { "total" number }
  { "rhm" rhythm }
}
{ $description "" } ;

HELP: absolute-rhythm-element
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

HELP: fuse-notes-deep
{ $values
  { "relts" { $sequence-of rhythm-element } }
  { "relts'" { $sequence-of rhythm-element } }
}
{ $description "" } ;

HELP: fuse-rests-deep
{ $values
  { "relts" { $sequence-of rhythm-element } }
  { "relts'" { $sequence-of rhythm-element } }
}
{ $description "" } ;

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

HELP: map-rhythm
{ $values
  { "relt" rhythm-element }
  { "quot" { $quotation "( ... value -- ... value' )" } }
  { "relt'" rhythm-element }
}
{ $description "If the input " { $link rhythm-element } " is a number, outputs the result of applying the quotation to that number.  If it is a " { $link rhythm } ", applies the quotation to each atomic " { $link rhythm-element } " of the rhythm, collecting new values in a new rhythm structure." }
{ $see-also map-rhythm! } ;

HELP: map-rhythm!
{ $values
  { "relt" rhythm-element }
  { "quot" { $quotation "( ... value -- ... value' )" } }
  { "relt'" rhythm-element }
}
{ $description "If the input " { $link rhythm-element } " is a number, outputs the result of applying the quotation to that number.  If it is a " { $link rhythm } ", applies the quotation to each atomic " { $link rhythm-element } " of the rhythm, replacing old values with new values in the same rhythm structure." }
{ $see-also map-rhythm } ;

OM-REFERENCE:
"projects/02-musicproject/functions/trees.lisp"
{ "build-one-measure" <measure> }
{ "simple->tree" zip-measures }
{ "better-predefined-subdiv?" (?split-heuristically) }
{ "fuse-pauses-and-tied-notes-between-beats" fuse-rests-and-ties }
{ "grouper1" fuse-notes-deep }
{ "grouper2" fuse-rests-deep }
{ "grouper3" fuse-rests-deep } ;

OM-REFERENCE:
"projects/02-musicproject/container/tree2container.lisp"
{ "resolve-?" >rhythm-element } ;

ARTICLE: "om.rhythm" "om.rhythm"
{ $aux-vocab-intro "om.rhythm" "om.trees" } ;

ABOUT: "om.rhythm"
