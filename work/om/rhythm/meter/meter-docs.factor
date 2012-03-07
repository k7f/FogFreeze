! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: help.markup help.syntax kernel math om.help.markup ;
IN: om.rhythm.meter

HELP: meter
{ $var-description "This is a special kind of rhythm duration serving as time signature of measures." } ;

HELP: <meter>
{ $values
  { "num" number }
  { "den" number }
  { "mtr" meter }
}
{ $description "" } ;

HELP: >meter
{ $values
  { "obj" object }
  { "mtr" meter }
}
{ $description "" } ;

ARTICLE: "om.rhythm.meter" "om.rhythm.meter"
{ $aux-vocab-intro "om.rhythm.meter" "om.trees" } ;

ABOUT: "om.rhythm.meter"
