! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.help.markup help.markup help.syntax kernel math om.help.markup
       sequences ;
IN: om.trees.onsets

HELP: onsets>increments
{ $values
  { "onsets" { $sequence-of number } }
  { "increments" { $sequence-of number } }
}
{ $description "" }
{ $see-also increments>onsets } ;

HELP: increments>onsets
{ $values
  { "start" number }
  { "increments" { $sequence-of number } }
  { "onsets" { $sequence-of number } }
}
{ $description "" }
{ $see-also onsets>increments } ;

HELP: global>local
{ $values
  { "global-onsets" { $sequence-of number } }
  { "global-start" number }
  { "local-onsets" { $sequence-of number } }
}
{ $description "" }
{ $notes "The elements of " { $snippet "global-onsets" } " aren't assumed to be sorted.  However, the absolute value of any element is expected to be greater than or equal to " { $snippet "global-start" } "."
  $nl
  "Due to the " { $link "note-or-rest-ambiguity" } ", the conversion is 1-based, i.e. " { $snippet "global-start" } " becomes local 1, and " { $snippet "global-start neg" } " becomes local -1."} ;

HELP: last-before
{ $values
  { "onsets" { $sequence-of number } }
  { "time" number }
  { "onset/f" { $maybe number } }
}
{ $description "" } ;

HELP: trim-between
{ $values
  { "onsets" { $sequence-of number } }
  { "start" number }
  { "stop" number }
  { "slice/f" { $maybe slice } }
}
{ $description "" }
{ $notes "The elements of " { $snippet "onsets" } " aren't assumed to be sorted.  The output is the minimal " { $link slice } " of " {  $snippet "onsets" } " such that no in-range element is left outside." }
{ $see-also trim-between* } ;

HELP: trim-between*
{ $values
  { "onsets" { $sequence-of number } }
  { "start" number }
  { "stop" number }
  { "onsets'" { $sequence-of number } }
}
{ $description "Like " { $link trim-between } ", but "
  { $list
    { "if there is a rest which extends over " { $snippet "start" } ", it is trimmed and prepended;" }
    { "the output sequence is of the same type as " { $snippet "onsets" } "." }
  }
}
{ $see-also trim-between } ;

ARTICLE: "note-or-rest-ambiguity" "note-or-rest ambiguity"
"Sign bit is used as the note-or-rest flag.  Therefore, in order to avoid the ambiguity, the lowest absolute value of a valid onset is 1." ;

ARTICLE: "om.trees.onsets" "om.trees.onsets"
{ $aux-vocab-intro "om.trees.onsets" "om.trees" } ;

ABOUT: "om.trees.onsets"
