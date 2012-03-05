! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.help.markup help.markup help.syntax math om.help.markup ;
IN: om.trees.measures

HELP: meter
{ $var-description "" } ;

HELP: measure
{ $var-description "" } ;

HELP: <measure>
{ $values
  { "onsets" { $sequence-of number } }
  { "num" number }
  { "den" number }
  { "measure" measure }
}
{ $description "" } ;

ARTICLE: "om.trees.measures" "om.trees.measures"
{ $aux-vocab-intro "om.trees.measures" "om.trees" } ;

ABOUT: "om.trees.measures"
