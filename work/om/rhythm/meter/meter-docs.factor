! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: help.markup help.syntax kernel math om.help.markup om.help.reference ;
IN: om.rhythm.meter

HELP: meter
{ $class-description "This is a special kind of rhythm duration serving as time signature of measures." } ;

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

OM-REFERENCE:
"projects/02-musicproject/container/tree2container.lisp"
{ "symbol->ratio" >meter } ;

ARTICLE: "om.rhythm.meter" "om.rhythm.meter"
{ $aux-vocab-intro "om.rhythm.meter" "om.trees" }
$nl
"Any pair of integers separated with " { $snippet "//" } " is accepted as a valid meter, if written inside rhythm literals.  Outside of rhythm literals, however, the notation " { $snippet "num//den" } " is restricted to a small, predefined subset of integer pairs." ;

ABOUT: "om.rhythm.meter"
