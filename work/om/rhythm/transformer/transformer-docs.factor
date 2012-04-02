! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.help.markup help.markup help.syntax kernel math om.help.markup
       om.help.reference om.rhythm refs sequences ;
IN: om.rhythm.transformer

HELP: rhythm-ref
{ $class-description "A reference to a " { $link rhythm-element } "."
  { $list
    { "Slot " { $snippet "index" } " is the element's local index in the " { $snippet "parent" } "'s division." }
    { "Slot " { $snippet "place" } " is the element's global index in the overall " { $link rhythm } "." } }
} ;

HELP: <rhythm-ref>
{ $values
  { "ndx" integer }
  { "parent/f" { $maybe rhythm } }
  { "relt/f" { $maybe rhythm-element } }
  { "ref" rhythm-ref }
}
{ $description "Creates a new " { $link rhythm-ref } ". Missing " { $link rhythm-element } " is supplied from the " { $snippet "parent" } "'s element at " { $snippet "ndx" } ". The " { $snippet "parent" } " is never modified, even if " { $snippet "relt" } " is explicitly specified." }
{ $notes "Failing to specify at least one of " { $snippet "parent" } " or " { $snippet "relt" } " raises an error." } ;

HELP: !rhythm-ref
{ $values
  { "ref" rhythm-ref }
}
{ $description "Updates the element referred to by a " { $link rhythm-ref } "." } ;

HELP: get-ref
{ $values
  { "ref" rhythm-ref }
  { "relt/f" { $maybe rhythm-element } }
}
{ $description "" } ;

HELP: set-ref
{ $values
  { "relt/f" { $maybe rhythm-element } }
  { "ref" rhythm-ref }
}
{ $description "" } ;

HELP: co-refs?
{ $values
  { "ref1" rhythm-ref }
  { "ref2" rhythm-ref }
  { "ref2/f" { $maybe rhythm-ref } }
}
{ $description "Outputs the second of two " { $link rhythm-ref } "s if they point to the same node of the same rhythmic structure; otherwise outputs " { $link POSTPONE: f } "." } ;

HELP: rhythm-transformer
{ $class-description "An auxiliary data structure facilitating " { $link rhythm } " traversal."
  $nl
  "The slot " { $snippet "refs" } " is a flat sequence of " { $link rhythm-ref } "s. Typically (although not necessarily) it is a subsequence of atomic " { $link rhythm-element } "s contained in the " { $snippet "underlying" } " " { $link rhythm } "."
  $nl
  "There are two ways of cloning a " { $link rhythm-transformer } "."
  { $list
    { "The method " { $link clone } " makes a copy of the " { $snippet "refs" } " sequence and its elements, but the new references still point to the original " { $snippet "underlying" } " " { $link rhythm } "." }
    { "The method " { $link clone-rhythm } ", additionally, makes a deep copy of the " { $snippet "underlying" } " " { $link rhythm } ", and points new references to it." }
  }
  $nl
  "Several rhythm-related words have methods defined for this type.  For example, if a " { $link rhythm-transformer } " is input to " { $link map-rests>notes } ", the result will be a new " { $link rhythm-transformer } " attached to a clone of the underlying " { $link rhythm } " of the input transformer, with all references redirected to the corresponding nodes of the new rhythm, and all rests replaced with notes in the new rhythm."
}
{ $see-also make-rhythm-transformer } ;

HELP: <rhythm-transformer>
{ $values
  { "rhm" rhythm }
  { "rt" rhythm-transformer }
}
{ $description "Creates a new " { $link rhythm-transformer } " containing " { $link rhythm-ref } "s to all atomic " { $link rhythm-element } "s of " { $snippet "rhm" } "."
  $nl
  "Global index is set to 0 for the first atom, and it is incremented for each subsequent atom." }
{ $see-also make-rhythm-transformer } ;

HELP: >rhythm-transformer<
{ $values
  { "rt" rhythm-transformer }
  { "rhm" rhythm }
}
{ $description "Outputs the underlying " { $link rhythm } " of a " { $link rhythm-transformer } " after updating " { $link rhythm-element } "s referred to by all valid " { $link rhythm-ref } "s." } ;

HELP: make-rhythm-transformer
{ $values
  { "rhm" rhythm }
  { "place" integer }
  { "increment" { $quotation "( ... value -- ... ? )" } }
  { "lastplace" integer }
  { "rt" rhythm-transformer }
}
{ $description "Creates a new " { $link rhythm-transformer } " containing " { $link rhythm-ref } "s to all atomic " { $link rhythm-element } "s of " { $snippet "rhm" } "."
  $nl
  "Global indexing of references is controlled by the predicate, which takes a numeric value of an atomic element and outputs a boolean indicating whether to increment the index for that atom, starting from " { $snippet "place" } " as the initial index value. The global index assigned to the last atom is output alongside the transformer." }
{ $notes "Although a typical caller discards it, the " { $snippet "lastplace" } " output is retained as a way to work around a compiler bug." }
{ $see-also <rhythm-transformer> make-rhythm-transformer* } ;

HELP: make-rhythm-transformer*
{ $values
  { "rhm" rhythm }
  { "place" integer }
  { "include" { $quotation "( ..a value -- ..b ? )" } }
  { "increment" { $quotation "( ..b value -- ..a ? )" } }
  { "lastplace" integer }
  { "rt" rhythm-transformer }
}
{ $description "Creates a new " { $link rhythm-transformer } " containing " { $link rhythm-ref } "s to atomic " { $link rhythm-element } "s of " { $snippet "rhm" } ", for which the predicate " { $snippet "include" } " outputs a true value."
  $nl
  "Global indexing of references is controlled by the predicate " { $snippet "increment" } ", which takes a numeric value of an atomic element and outputs a boolean indicating whether to increment the index for that atom, starting from " { $snippet "place" } " as the initial index value. The global index assigned to the last atom is output alongside the transformer." }
{ $notes "Although a typical caller discards it, the " { $snippet "lastplace" } " output is retained as a way to work around a compiler bug." }
{ $see-also <rhythm-transformer> make-rhythm-transformer } ;

HELP: make-note-transformer
{ $values
  { "rhm" rhythm }
  { "place" integer }
  { "lastplace" integer }
  { "rt" rhythm-transformer }
}
{ $description "Creates a new " { $link rhythm-transformer } " containing " { $link rhythm-ref } "s to all atomic " { $link rhythm-element } "s of " { $snippet "rhm" } "."
  $nl
  "Global index starts from " { $snippet "place" } " and is incremented for each note." }
{ $notes "Although a typical caller discards it, the " { $snippet "lastplace" } " output is retained as a way to work around a compiler bug." }
{ $see-also make-note-transformer* make-rhythm-transformer } ;

HELP: make-note-transformer*
{ $values
  { "rhm" rhythm }
  { "place" integer }
  { "lastplace" integer }
  { "rt" rhythm-transformer }
}
{ $description "Creates a new " { $link rhythm-transformer } " containing " { $link rhythm-ref } "s to all atomic " { $link rhythm-element } "s of " { $snippet "rhm" } ", excluding rests."
  $nl
  "Global index starts from " { $snippet "place" } " and is incremented for each note." }
{ $notes "Although a typical caller discards it, the " { $snippet "lastplace" } " output is retained as a way to work around a compiler bug." }
{ $see-also make-note-transformer make-rhythm-transformer* } ;

HELP: group-notes
{ $values
  { "obj" object }
  { "slices" { $sequence-of slice } }
}
{ $description "Outputs a sequence of all notes of a " { $link rhythm } ".  Each note is represented by a slice containing " { $link rhythm-ref } "s to the note proper and its tied continuations."
  $nl
  "The rhythm may be provided directly or wrapped in a rhythm-handling type." } ;

HELP: each-note-slice
{ $values
  { "obj" object }
  { "quot" { $quotation "( ... slice -- ... )" } }
}
{ $description "Applies the quotation to each note of a " { $link rhythm } ".  The note is passed as a slice containing " { $link rhythm-ref } "s to the note proper and its tied continuations."
  $nl
  "The rhythm may be provided directly or wrapped in a rhythm-handling type." } ;

HELP: map-note-slices
{ $values
  { "obj" object }
  { "quot" { $quotation "( ... slice -- ... seq )" } }
  { "obj'" object }
}
{ $description "Applies the quotation to each note of a " { $link rhythm } "'s clone.  The note is passed as a slice containing " { $link rhythm-ref } "s to the note proper and its tied continuations.  The quotation is expected to output a sequence of " { $link rhythm-ref } "s, as a way of selecting the " { $link rhythm-element } "s which should be updated."
  $nl
  "The rhythm may be provided directly or wrapped in a rhythm-handling type." }
{ $see-also map-note-slices! } ;

HELP: map-note-slices!
{ $values
  { "obj" object }
  { "quot" { $quotation "( ... slice -- ... seq )" } }
  { "obj'" object }
}
{ $description "Applies the quotation to each note of a " { $link rhythm } ".  The note is passed as a slice containing " { $link rhythm-ref } "s to the note proper and its tied continuations.  The quotation is expected to output a sequence of " { $link rhythm-ref } "s, as a way of selecting the " { $link rhythm-element } "s which should be updated."
  $nl
  "The rhythm may be provided directly or wrapped in a rhythm-handling type." }
{ $see-also map-note-slices } ;

OM-REFERENCE:
"projects/02-musicproject/functions/trees.lisp"
{ "treeobj" rhythm-ref "type" }
{ "trans-tree" <rhythm-transformer> }
{ "trans-obj" >rhythm-transformer< }
{ "transform-rests" map-rests>notes! }
{ "transform-notes-flt" submap-notes>rests! }
{ "trans-note-index" make-note-transformer } ;

ARTICLE: "om.rhythm.transformer" "om.rhythm.transformer"
{ $aux-vocab-intro "om.rhythm.transformer" "om.trees" } ;

ABOUT: "om.rhythm.transformer"
