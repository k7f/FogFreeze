! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.help.markup help.markup help.syntax math om.help.markup ;
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

ARTICLE: "om.rhythm" "om.rhythm"
{ $aux-vocab-intro "om.rhythm" "om.trees" } ;

ABOUT: "om.rhythm"
