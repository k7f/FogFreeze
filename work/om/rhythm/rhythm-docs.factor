! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.help.markup arrays assocs help.markup help.syntax kernel math
       om.help.markup om.help.reference om.rhythm.meter om.rhythm.private
       sequences ;
IN: om.rhythm

HELP: rhythm
{ $class-description "The main abstract class combining all types used for directly storing or indirectly referring to rhythmic structures.  Any " { $link rhythm } " type has to implement the " { $link >rhythm-element } " accessor method returning its underlying rhythmic structure.  It may also implement the " { $link clone-rhythm } " method." } ;

HELP: rhythm-duration
{ $class-description "A numeric value or a " { $link meter } "." } ;

HELP: rhythm-tree
{ $class-description "A rhythm tree."
  { $list
    { "Slot " { $snippet "duration" } " may hold a " { $link rhythm-duration } " or may be left without an explicit value." }
    { "Slot " { $snippet "division" } " is " { $sequence-of rhythm-element } "." }
  }
} ;

HELP: rhythm-element
{ $class-description "A rhythmic structure: a numeric atom or a " { $link rhythm-tree } ".  It may serve as a node in a rhythm tree."
  $nl
  "Standard interpretation of atomic rhythm elements is defined for three subdomains:"
  { $list
    { "positive " { $link integer } "s are notes;" }
    { "negative " { $link integer } "s are rests;" }
    { "positive " { $link float } "s are tied continuations of previous notes." }
  }
} ;

HELP: >rhythm-element
{ $values
  { "obj" object }
  { "relt" rhythm-element }
}
{ $description "" } ;

HELP: clone-rhythm
{ $values
  { "obj" object }
  { "cloned" object }
}
{ $contract "Given a " { $link rhythm-tree } " object, the output is a deep copy of the entire rhythm tree.  If a method is defined for a rhythm-handling type, it will perform deep copy of its underlying rhythm tree." } ;

HELP: >rhythm-duration
{ $values
  { "obj" object }
  { "dur" rhythm-duration }
}
{ $description "" } ;

HELP: <rhythm>
{ $values
  { "dur" object }
  { "dvn" sequence }
  { "rtree" rhythm-tree }
}
{ $description "" } ;

HELP: ?change-division
{ $values
  { "rtree" rhythm-tree }
  { "quot" { $quotation "( ... value -- ... value' ? )" } }
  { "rtree" rhythm-tree }
  { "?" boolean }
}
{ $description "" } ;

HELP: onsets>rhythm
{ $values
  { "onsets" { $sequence-of number } }
  { "rtree" rhythm-tree }
}
{ $description "" } ;

HELP: absolute-rhythm
{ $values
  { "onsets" { $sequence-of number } }
  { "total" number }
  { "rtree" rhythm-tree }
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

HELP: ?fuse-notes-deep
{ $values
  { "relts" { $sequence-of rhythm-element } }
  { "relts'" { $sequence-of rhythm-element } }
  { "?" boolean }
}
{ $description "" } ;

HELP: fuse-notes-deep
{ $values
  { "relts" { $sequence-of rhythm-element } }
  { "relts'" { $sequence-of rhythm-element } }
}
{ $description "" } ;

HELP: ?fuse-rests-deep
{ $values
  { "relts" { $sequence-of rhythm-element } }
  { "relts'" { $sequence-of rhythm-element } }
  { "?" boolean }
}
{ $description "" } ;

HELP: fuse-rests-deep
{ $values
  { "relts" { $sequence-of rhythm-element } }
  { "relts'" { $sequence-of rhythm-element } }
}
{ $description "" } ;

HELP: measure
{ $class-description "This is a special kind of " { $link rhythm-tree } ", whose " { $snippet "duration" } " slot holds a " { $link meter } "." } ;

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
  { "rtree" rhythm-tree }
}
{ $description "Takes a sequence of durations followed by a sequence of time signatures, and outputs a corresponding " { $link rhythm-tree } ", which contains a sequence of " { $link measure } "s in the " { $snippet "division" } " slot." } ;

HELP: map-rhythm
{ $values
  { "relt" rhythm-element }
  { "quot" { $quotation "( ... value -- ... value' )" } }
  { "relt'" rhythm-element }
}
{ $description "If the input " { $link rhythm-element } " is a number, outputs the result of applying the quotation to that number.  If it is a " { $link rhythm-tree } ", applies the quotation to each atomic " { $link rhythm-element } " of the rhythm, collecting new values in a new rhythm structure." }
{ $see-also map-rhythm! } ;

HELP: map-rhythm!
{ $values
  { "relt" rhythm-element }
  { "quot" { $quotation "( ... value -- ... value' )" } }
  { "relt'" rhythm-element }
}
{ $description "If the input " { $link rhythm-element } " is a number, outputs the result of applying the quotation to that number.  If it is a " { $link rhythm-tree } ", applies the quotation to each atomic " { $link rhythm-element } " of the rhythm, replacing old values with new values in the same rhythm structure." }
{ $see-also map-rhythm } ;

HELP: map-rests>notes
{ $values
  { "obj" object }
  { "obj'" object }
}
{ $contract "Given a " { $link rhythm-tree } " object outputs a deep copy of the entire rhythm tree with all rests replaced with notes.  If a method is defined for a rhythm-handling type, it will perform deep copy of its underlying rhythm and replace all rests with notes in it." }
{ $see-also map-rests>notes! } ;

HELP: map-rests>notes!
{ $values
  { "obj" object }
  { "obj'" object }
}
{ $contract "Given a " { $link rhythm-tree } " object outputs the input rhythm modified by replacing all rests with notes.  If a method is defined for a rhythm-handling type, it will replace all rests with notes in its underlying rhythm." }
{ $see-also map-rests>notes } ;

HELP: map-notes>rests
{ $values
  { "obj" object }
  { "obj'" object }
}
{ $contract "Given a " { $link rhythm-tree } " object outputs a deep copy of the entire rhythm tree with all notes replaced with rests.  If a method is defined for a rhythm-handling type, it will perform deep copy of its underlying rhythm and replace all notes with rests in it." }
{ $see-also map-notes>rests! } ;

HELP: map-notes>rests!
{ $values
  { "obj" object }
  { "obj'" object }
}
{ $contract "Given a " { $link rhythm-tree } " object outputs the input rhythm modified by replacing all notes with rests.  If a method is defined for a rhythm-handling type, it will replace all notes with rests in its underlying rhythm." }
{ $see-also map-notes>rests } ;

HELP: submap-notes>rests
{ $values
  { "obj" object }
  { "places" { $sequence-of integer } }
  { "obj'" object }
}
{ $contract "Given a " { $link rhythm-tree } " object outputs a deep copy of the entire rhythm tree with selected notes replaced with rests.  The " { $snippet "places" } " sequence specifies the selection."
  $nl
  "If a method is defined for a rhythm-handling type, it will perform deep copy of its underlying rhythm and replace selected notes with rests in it." }
{ $see-also submap-notes>rests! } ;

HELP: submap-notes>rests!
{ $values
  { "obj" object }
  { "places" { $sequence-of integer } }
  { "obj'" object }
}
{ $contract "Given a " { $link rhythm-tree } " object outputs the input rhythm modified by replacing selected notes with rests.  The " { $snippet "places" } " sequence specifies the selection."
  $nl
  "If a method is defined for a rhythm-handling type, it will replace selected notes with rests in its underlying rhythm." }
{ $see-also submap-notes>rests } ;

HELP: rhythm-substitute
{ $values
  { "rhm" rhythm }
  { "assoc" assoc }
  { "rhm'" rhythm }
}
{ $description "Creates a new object of the same type as input rhythm, where any atomic " { $link rhythm-element } " which appears as a key in " { $snippet "assoc" } " is replaced by the corresponding value, and all other elements are unchanged." }
{ $see-also rhythm-substitute! } ;

HELP: rhythm-substitute!
{ $values
  { "rhm" rhythm }
  { "assoc" assoc }
  { "rhm" rhythm }
}
{ $description "Finds all atomic " { $link rhythm-element } "s of input rhythm which appear as keys in " { $snippet "assoc" } " and replaces them by the corresponding values, leaving all other elements unchanged." }
{ $see-also rhythm-substitute } ;

HELP: rhythm-atoms
{ $values
  { "rhm" rhythm }
  { "atoms" { $sequence-of number } }
}
{ $contract "Outputs a flat sequence containing all atoms of a " { $link rhythm } "." } ;

HELP: {<
{ $syntax "{< tokens... >}" }
{ $values
  { "tokens" "a list of strings representing a " { $link rhythm-duration } " followed by a list of " { $link rhythm-element } "s" }
}
{ $description "Marks the beginning of a literal " { $link rhythm-tree } ".  Literal rhythms are terminated by " { $link POSTPONE: >} } "."
  $nl
  "A numeric duration token must be followed by the separator \"><\".  The separator may be omitted after non-numeric duration tokens.  If the first token parses to a number and isn't followed by the separator, it is implicitly preceded by two extra tokens: \"1\" and \"><\".  The same two extra tokens are prepended, if the first explicit token is the \"{<\"."
  $nl
  "Two special forms of duration token are allowed, apart from numeric and metric duration:"
  { $list
    { "the " { $snippet "t" } " form is substituted by the sum of all element durations;" }
    { "the " { $snippet "f" } " form postpones the computation and parses to an unspecified duration." }
  }
}
{ $notes 
  { $list
    "If literal rhythm has empty contents, it is interpreted as a unit duration rest.  The unit at the top level is semibreve (whole note).  The unit at lower levels is context-dependent."
    { "If there is only one token inside, it is interpreted as a single-element rhythm, whose details are type-dependent."
      { $list
        { "If the token parses to a number, the value of the " { $link rhythm-element } " is that number, and " { $link rhythm-duration } " is its absolute integer part." }
        { "If the token parses to a " { $link meter } ", the duration is that meter, and the rhythm contains a single rest." }
        { "The token " { $snippet "t" } " is ignored (hence the literal rhythm parses to a unit duration rest)." }
        { "The token " { $snippet "f" } " is interpreted as a single rest of unspecified duration." }
      }
    }
  }
}
{ $examples
  "A single measure with a rest on the first beat, followed by two crotchets:"
  { $code "{< 3//4 -1 1 1 >}" }
  "A variation: a quaver tripplet on the second beat and a tie to the third beat:"
  { $code "{< 3//4 -1 {< 1 1 1 >} 1. >}" }
  "A single note of unspecified duration:"
  { $code "{< f 1 >}" }
  "Two notes, each of unit duration:"
  { $code "{< t 1 1 >}" }
  "Two notes, each of half-unit duration:"
  { $code "{< 1 1 >}" }
  "Two notes, each of one-and-half-unit duration:"
  { $code "{< 3 >< 1 1 >}" }
} ;

HELP: >}
{ $syntax ">}" }
{ $description "Marks the end of a literal " { $link rhythm-tree } "." } ;

{ POSTPONE: {< POSTPONE: >} } related-words

OM-REFERENCE:
"projects/02-musicproject/functions/trees.lisp"
{ "build-one-measure" <measure> }
{ "simple->tree" zip-measures }
{ "better-predefined-subdiv?" (?split-heuristically) }
{ "fuse-pauses-and-tied-notes-between-beats" fuse-rests-and-ties }
{ "grouper1" fuse-notes-deep }
{ "grouper2" fuse-rests-deep }
{ "grouper3" fuse-rests-deep }
{ "remove-rests" map-rests>notes }
{ "remove-rests" map-rests>notes! }
{ "give-pulse" rhythm-atoms } ;

OM-REFERENCE:
"projects/02-musicproject/container/tree2container.lisp"
{ "resolve-?" >rhythm-element } ;

ARTICLE: "om.rhythm" "om.rhythm"
{ $aux-vocab-intro "om.rhythm" "om.trees" } ;

ABOUT: "om.rhythm"
