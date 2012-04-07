! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors addenda.help.markup addenda.math ascii effects help.markup
       help.syntax kernel math om.help.markup om.help.reference sequences
       vocabs words ;
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
{ $description "Converts the input object to a meter.  Convertible object types are: strings in the form " { $snippet "\"num//den\"" } ", two-element sequences, and " { $input-types >meter { sequence } "no more" } "." } ;

OM-REFERENCE:
"projects/02-musicproject/container/tree2container.lisp"
{ "symbol->ratio" >meter } ;

OM-REFERENCE:
"kernel/tools/lisptools.lisp"
{ "fullratio" >rational } ;

<PRIVATE
: ($literal-meters) ( elements -- )
    drop "om.rhythm.meter" words [
        dup name>> first digit? [
            "declared-effect" word-prop ( -- x ) effect=
        ] [ drop f ] if
    ] filter
    [ " " print-element ] [ ($link) ] interleave ;
PRIVATE>

ARTICLE: "literal-meters" "Literal meters"
"Any pair of integers separated with " { $snippet "//" } " is accepted as a valid literal meter if written inside of a rhythm literal.  Outside of rhythm literals, however, the notation " { $snippet "num//den" } " is restricted to a small, predefined subset of integer pairs listed below."
$nl
{ ($literal-meters) } ;

ARTICLE: "om.rhythm.meter" "om.rhythm.meter"
{ $aux-vocab-intro "om.rhythm.meter" "om.trees" }
$nl
{ $subsections "literal-meters" } ;

ABOUT: "om.rhythm.meter"
