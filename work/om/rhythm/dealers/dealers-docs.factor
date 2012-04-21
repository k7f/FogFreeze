! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.help.markup classes help.markup help.syntax kernel math
       om.help.markup om.help.reference om.rhythm refs sequences ;
IN: om.rhythm.dealers

HELP: rhythm-ref
{ $class-description "A reference to a " { $link rhythm-element } ".  Slot " { $snippet "index" } " is the element's local index in the " { $snippet "parent" } "'s division." } ;

HELP: <rhythm-ref>
{ $values
  { "ndx" integer }
  { "parent/f" { $maybe rhythm-tree } }
  { "relt/f" { $maybe rhythm-element } }
  { "ref" rhythm-ref }
}
{ $description "Creates a new " { $link rhythm-ref } ". Missing " { $link rhythm-element } " is supplied from the " { $snippet "parent" } "'s element at " { $snippet "ndx" } ". The " { $snippet "parent" } " is never modified, even if " { $snippet "relt" } " is explicitly specified." }
{ $notes "Failing to specify at least one of " { $snippet "parent" } " or " { $snippet "relt" } " raises an error." } ;

HELP: !rhythm-ref
{ $values
  { "ref" rhythm-ref }
}
{ $description "A commit operation: updates the element referred to by a " { $link rhythm-ref } "." } ;

HELP: fit-ref
{ $values
  { "relt" rhythm-element }
  { "ref" rhythm-ref }
}
{ $description "Stores the " { $link rhythm-element } " as the new value of the reference without updating the actual element currently referred to by the " { $link rhythm-ref } ".  For atomic input this is equivalent to " { $link set-ref } ".  If " { $snippet "relt" } " is a " { $link rhythm-tree } ", its duration is set to the duration of the value it replaces." } ;

HELP: co-refs?
{ $values
  { "ref1" rhythm-ref }
  { "ref2" rhythm-ref }
  { "ref2/f" { $maybe rhythm-ref } }
}
{ $description "Outputs the second of two " { $link rhythm-ref } "s if they point to the same node of the same rhythmic structure; otherwise outputs " { $link POSTPONE: f } "." } ;

HELP: rhythm-dealer
{ $class-description "An auxiliary data structure facilitating " { $link rhythm-tree } " traversal."
  $nl
  "The slot " { $snippet "refs" } " is a flat sequence of " { $link rhythm-ref } "s. Typically (although not necessarily) it is a subsequence of atomic " { $link rhythm-element } "s contained in the " { $snippet "underlying" } " " { $link rhythm-tree } "."
  $nl
  "There are two ways of cloning a " { $link rhythm-dealer } "."
  { $list
    { "The method " { $link clone } " makes a copy of the " { $snippet "refs" } " sequence and its elements, but the new references still point to the original " { $snippet "underlying" } " " { $link rhythm-tree } "." }
    { "The method " { $link clone-rhythm } ", additionally, makes a deep copy of the " { $snippet "underlying" } " " { $link rhythm-tree } ", and points new references to it." }
  }
  $nl
  "Since " { $link rhythm-dealer } " is an instance of " { $link rhythm } ", several rhythm-related generic words have methods defined for this type.  For example, if a " { $link rhythm-dealer } " is input to " { $link map-rests>notes } ", the result will be a new " { $link rhythm-dealer } " attached to a clone of the underlying " { $link rhythm-tree } " of the input dealer, with all references redirected to the corresponding nodes of the new rhythmic structure, and all rests replaced with notes in the new structure."
}
{ $see-also <rhythm-dealer> } ;

HELP: new-rhythm-dealer
{ $values
  { "rtree" rhythm-tree }
  { "class" class }
  { "rdeal" rhythm-dealer }
}
{ $description "Parametric constructor of " { $link rhythm-dealer } "s.  Creates a new object containing " { $link rhythm-ref } "s to all atomic " { $link rhythm-element } "s of " { $snippet "rtree" } "." }
{ $see-also <rhythm-dealer> } ;

HELP: <rhythm-dealer>
{ $values
  { "rtree" rhythm-tree }
  { "rdeal" rhythm-dealer }
}
{ $description "Creates a new " { $link rhythm-dealer } " containing " { $link rhythm-ref } "s to all atomic " { $link rhythm-element } "s of " { $snippet "rtree" } "." }
{ $see-also new-rhythm-dealer make-rhythm-dealer } ;

HELP: >rhythm-dealer<
{ $values
  { "rdeal" rhythm-dealer }
  { "rtree" rhythm-tree }
}
{ $description "Outputs the underlying " { $link rhythm-tree } " of the " { $link rhythm-dealer } ", after updating " { $link rhythm-element } "s referred to by all valid " { $link rhythm-ref } "s." } ;

HELP: make-rhythm-dealer
{ $values
  { "rtree" rhythm-tree }
  { "include" { $quotation "( ... value -- ... ? )" } }
  { "rdeal" rhythm-dealer }
}
{ $description "Creates a new " { $link rhythm-dealer } " containing " { $link rhythm-ref } "s to atomic " { $link rhythm-element } "s of " { $snippet "rtree" } ", for which the predicate " { $snippet "include" } " outputs a true value." }
{ $see-also <rhythm-dealer> } ;

HELP: make-note-dealer
{ $values
  { "rtree" rhythm-tree }
  { "rdeal" rhythm-dealer }
}
{ $description "Creates a new " { $link rhythm-dealer } " containing " { $link rhythm-ref } "s to all atomic " { $link rhythm-element } "s of " { $snippet "rtree" } ", excluding rests." }
{ $see-also make-rhythm-dealer } ;

HELP: clone-rhythm-dealer
{ $values
  { "rdeal" rhythm-dealer }
  { "rdeal'" rhythm-dealer }
}
{ $description "Creates a new object containing a deep copy of the input's underlying " { $link rhythm-tree } " and a copy of its references.  The class of input object may be any subclass of " { $link rhythm-dealer } "."
  $nl
  "This word simplifies the implementation of " { $link clone-rhythm } " methods." }
{ $see-also clone-rhythm } ;

HELP: group-notes
{ $values
  { "rhm" rhythm }
  { "slices" { $sequence-of slice } }
}
{ $description "Outputs a sequence of all notes of a " { $link rhythm } ".  Each note is represented by a slice containing " { $link rhythm-ref } "s to the note proper and its tied continuations."
  $nl
  "The rhythm may be provided directly or wrapped in a rhythm-handling type." } ;

HELP: each-note-slice
{ $values
  { "rhm" rhythm }
  { "quot" { $quotation "( ... slice -- ... )" } }
}
{ $description "Applies the quotation to each note of a " { $link rhythm } ".  The note is passed as a slice containing " { $link rhythm-ref } "s to the note proper and its tied continuations."
  $nl
  "The rhythm may be provided directly or wrapped in a rhythm-handling type." } ;

HELP: map-note-slices
{ $values
  { "rhm" rhythm }
  { "quot" { $quotation "( ... slice -- ... seq )" } }
  { "rhm'" rhythm }
}
{ $description "Applies the quotation to each note of a " { $link rhythm } "'s clone.  The note is passed as a slice containing " { $link rhythm-ref } "s to the note proper and its tied continuations.  The quotation is expected to output a sequence of " { $link rhythm-ref } "s, as a way of selecting the " { $link rhythm-element } "s which should be updated."
  $nl
  "The rhythm may be provided directly or wrapped in a rhythm-handling type." }
{ $see-also map-note-slices! } ;

HELP: map-note-slices!
{ $values
  { "rhm" rhythm }
  { "quot" { $quotation "( ... slice -- ... seq )" } }
  { "rhm" rhythm }
}
{ $description "Applies the quotation to each note of a " { $link rhythm } ".  The note is passed as a slice containing " { $link rhythm-ref } "s to the note proper and its tied continuations.  The quotation is expected to output a sequence of " { $link rhythm-ref } "s, as a way of selecting the " { $link rhythm-element } "s which should be updated."
  $nl
  "The rhythm may be provided directly or wrapped in a rhythm-handling type." }
{ $see-also map-note-slices } ;

OM-REFERENCE:
"projects/02-musicproject/functions/trees.lisp"
{ "treeobj" rhythm-ref "type" }
{ "trans-tree" <rhythm-dealer> }
{ "trans-tree-index" <rhythm-dealer> }
{ "trans-obj" >rhythm-dealer< }
{ "transform-rests" map-rests>notes! }
{ "trans-note-index" make-note-dealer } ;

ARTICLE: "om.rhythm.dealers" "om.rhythm.dealers"
{ $aux-vocab-intro "om.rhythm.dealers" "om.trees" } ;

ABOUT: "om.rhythm.dealers"
