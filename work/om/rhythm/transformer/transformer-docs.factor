! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.help.markup help.markup help.syntax kernel math om.help.markup
       om.help.reference om.rhythm om.rhythm.dealers refs sequences ;
IN: om.rhythm.transformer

HELP: rhythm-transformer
{ $class-description "An auxiliary data structure facilitating " { $link rhythm-tree } " traversal."
  $nl
  "The slot " { $snippet "refs" } " is a flat sequence of " { $link rhythm-ref } "s. Typically (although not necessarily) it is a subsequence of atomic " { $link rhythm-element } "s contained in the " { $snippet "underlying" } " " { $link rhythm-tree } "."
  $nl
  "The slot " { $snippet "event-indices" } " partitions the sequence of references into a sequence of events.  It assigns to each reference a corresponding element's event index, global for the overall " { $link rhythm-tree } "."
  $nl
  "There are two ways of cloning a " { $link rhythm-transformer } "."
  { $list
    { "The method " { $link clone } " makes a copy of the " { $snippet "refs" } " sequence and its elements, but the new references still point to the original " { $snippet "underlying" } " " { $link rhythm-tree } "." }
    { "The method " { $link clone-rhythm } ", additionally, makes a deep copy of the " { $snippet "underlying" } " " { $link rhythm-tree } ", and points new references to it." }
  }
  $nl
  "Since " { $link rhythm-transformer } " is an instance of " { $link rhythm } ", several rhythm-related generic words have methods defined for this type.  For example, if a " { $link rhythm-transformer } " is input to " { $link map-rests>notes } ", the result will be a new " { $link rhythm-transformer } " attached to a clone of the underlying " { $link rhythm-tree } " of the input transformer, with all references redirected to the corresponding nodes of the new rhythmic structure, and all rests replaced with notes in the new structure."
}
{ $see-also <rhythm-transformer> make-rhythm-transformer make-rhythm-transformer* } ;

HELP: <rhythm-transformer>
{ $values
  { "rtree" rhythm-tree }
  { "rtf" rhythm-transformer }
}
{ $description "Creates a new " { $link rhythm-transformer } " containing " { $link rhythm-ref } "s to all atomic " { $link rhythm-element } "s of " { $snippet "rtree" } "."
  $nl
  "Global event index is set to 0 for the first atom, and it is incremented for each subsequent atom." }
{ $see-also make-rhythm-transformer make-rhythm-transformer* } ;

HELP: >rhythm-transformer<
{ $values
  { "rtf" rhythm-transformer }
  { "rtree" rhythm-tree }
}
{ $description "Outputs the underlying " { $link rhythm-tree } " of the " { $link rhythm-transformer } " after updating " { $link rhythm-element } "s referred to by all valid " { $link rhythm-ref } "s." } ;

HELP: renumber-rhythm-events
{ $values
  { "rtf" rhythm-transformer }
  { "place" integer }
  { "increment" { $quotation "( ... value -- ... ? )" } }
  { "rtf" rhythm-transformer }
}
{ $description "Creates a new sequence of global event indices and stores that sequence in the " { $link rhythm-transformer } "."
  $nl
  "The indexing of references is controlled by the predicate " { $snippet "increment" } ", which takes a value being referred to and outputs a boolean indicating whether to pre-increment the index for the reference, starting from " { $snippet "place" } " as the initial index value." } ;

HELP: make-rhythm-transformer*
{ $values
  { "rtree" rhythm-tree }
  { "place" integer }
  { "increment" { $quotation "( ... value -- ... ? )" } }
  { "rtf" rhythm-transformer }
}
{ $description "Creates a new " { $link rhythm-transformer } " containing " { $link rhythm-ref } "s to all atomic " { $link rhythm-element } "s of " { $snippet "rtree" } "."
  $nl
  "Global indexing of references is controlled by the predicate " { $snippet "increment" } ", which takes a value being referred to and outputs a boolean indicating whether to pre-increment the index for the reference, starting from " { $snippet "place" } " as the initial index value." }
{ $see-also <rhythm-transformer> make-rhythm-transformer make-rhythm-transformer* } ;

HELP: make-rhythm-transformer
{ $values
  { "rtree" rhythm-tree }
  { "place" integer }
  { "include" { $quotation "( ..a value -- ..b ? )" } }
  { "increment" { $quotation "( ..b value -- ..a ? )" } }
  { "rtf" rhythm-transformer }
}
{ $description "Creates a new " { $link rhythm-transformer } " containing " { $link rhythm-ref } "s to atomic " { $link rhythm-element } "s of " { $snippet "rtree" } ", for which the predicate " { $snippet "include" } " outputs a true value."
  $nl
  "Global indexing of references is controlled by the predicate " { $snippet "increment" } ", which takes a value being referred to and outputs a boolean indicating whether to pre-increment the index for the reference, starting from " { $snippet "place" } " as the initial index value." }
{ $see-also <rhythm-transformer> make-rhythm-transformer } ;

HELP: make-note-transformer*
{ $values
  { "rtree" rhythm-tree }
  { "place" integer }
  { "rtf" rhythm-transformer }
}
{ $description "Creates a new " { $link rhythm-transformer } " containing " { $link rhythm-ref } "s to all atomic " { $link rhythm-element } "s of " { $snippet "rtree" } "."
  $nl
  "Global index starts from " { $snippet "place" } " and is incremented for each note." }
{ $see-also make-note-transformer make-rhythm-transformer* } ;

HELP: make-note-transformer
{ $values
  { "rtree" rhythm-tree }
  { "place" integer }
  { "rtf" rhythm-transformer }
}
{ $description "Creates a new " { $link rhythm-transformer } " containing " { $link rhythm-ref } "s to all atomic " { $link rhythm-element } "s of " { $snippet "rtree" } ", excluding rests."
  $nl
  "Global index starts from " { $snippet "place" } " and is incremented for each note." }
{ $see-also make-note-transformer* make-rhythm-transformer } ;

HELP: rhythm-change-nths
{ $values
  { "rhm" rhythm }
  { "places" { $sequence-of integer } }
  { "values" { $sequence-of rhythm-element } }
  { "rhm" rhythm }
}
{ $description "Modifies rhythm by substituting selected " { $link rhythm-element } "s with subsequent " { $snippet "values" } ".  The sequence of global event indices, " { $snippet "places" } ", defines the selection."
  $nl
  "When substituting a tree for an element (atomic or not), the old element's duration becomes the new duration of the tree, and the overall rhythm duration is preserved.  When the new value is an atom, it is stored unmodified, but the overall rhythm duration may change." } ;

OM-REFERENCE:
"projects/02-musicproject/functions/trees.lisp"
{ "trans-tree" <rhythm-transformer> }
{ "trans-tree-index" <rhythm-transformer> }
{ "trans-obj" >rhythm-transformer< }
{ "transform-notes-flt" submap-notes>rests! }
{ "trans-note-index" make-note-transformer }
{ "trans-note-index" make-note-transformer* }
{ "substreeall" rhythm-change-nths } ;

ARTICLE: "om.rhythm.transformer" "om.rhythm.transformer"
{ $aux-vocab-intro "om.rhythm.transformer" "om.trees" } ;

ABOUT: "om.rhythm.transformer"
