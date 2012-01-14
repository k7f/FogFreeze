! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: help.markup help.syntax math om.support sequences ;
IN: om.series

HELP: x->dx
{ $values
  { "seq" sequence }
  { "seq'" sequence }
}
{ $description "Computes a list of intervals from a list of points."
$nl
"x->dx can be used for instance to get intervals from absolute pitches or to get a list of durations from time onsets." } ;

HELP: dx->x
{ $values
  { "start" number }
  { "seq" sequence }
  { "seq'" sequence }
}
{ $description "Computes a list of points from a list of intervals and a initial point (" { $snippet "start" } ")."
$nl
"dx->x can be used for instance to get absolute pitches from intervals or to get onsets from durations." } ;

HELP: arithm-ser
{ $values
  { "begin" number }
  { "end" number }
  { "step" number }
  { "&optionals" optionals }
  { "seq" sequence }
}
{ $description "Arithmetic series: returns a list of numbers from " { $snippet "begin" } " to " { $snippet "end" } " with increment of " { $snippet "step" } "." }
{ $notes { $snippet "nummax" } " allows to limit the number of elements returned." } ;

ARTICLE: "om.series" "om.series"
"The " { $vocab-link "om.series" } " vocabulary is an experimental port of the file " { $snippet "projects/01-basicproject/functions/series.lisp" } " from the main " { $snippet "code" } " tree of OpenMusic."
$nl
"The text in descriptions and notes was copied verbatim from the original docstrings.  There may be little or no meaning left in it after the transfer." ;

ABOUT: "om.series"
