! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: help.markup help.syntax kernel math om.support sequences ;
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
  { "&optionals" object }
  { "seq" sequence }
}
{ $description "Arithmetic series: returns a list of numbers from " { $snippet "begin" } " to " { $snippet "end" } " with increment of " { $snippet "step" } "." }
{ $notes { $snippet "nummax" } " allows to limit the number of elements returned." } ;

HELP: fibo-ser
{ $values
  { "seed1" number }
  { "seed2" number }
  { "limit" number }
  { "&optionals" object }
  { "seq" sequence }
}
{ $description "Fibonacci series: f(i) = f(i-1) + f(i-2)."
$nl
{ $snippet "seed1" } " = f(0) the first element of the series."
$nl
{ $snippet "seed2" } " = f(1) the second element of the series."
$nl
{ $snippet "limit" } " is the limit of this list."
$nl
{ $snippet "begin" } " and " { $snippet "end" } " can be used to limit the calculation of the series." } ;

HELP: geometric-ser
{ $values
  { "seed" number }
  { "factor" number }
  { "limit" number }
  { "&optionals" object }
  { "seq" sequence }
}
{ $description "Geometric series: starts from " { $snippet "seed" } " and returns a list with f(i) = factor * f(i-1)."
$nl
{ $snippet "limit" } " is the limit of returned list list."
$nl
{ $snippet "begin" } " and " { $snippet "end" } " allow to delimit the series."
$nl
{ $snippet "nummax" } " allows to limit the number of elements." } ;

HELP: prime-ser
{ $values
  { "max-value" number }
  { "&optionals" object }
  { "seq" sequence }
}
{ $description "Prime numbers series: returns the set of prime-numbers ranging from 0 upto " { $snippet "max" } "."
$nl
"The optional parametre " { $snippet "numelem" } " limits the number of elements." } ;

HELP: inharm-ser
{ $values
  { "start" number }
  { "dist" number }
  { "npart" number }
  { "seq" sequence }
}
{ $description "Generates a list of " { $snippet "npart" } " partials from " { $snippet "begin" } " when partial n = " { $snippet "begin" } " * n^" { $snippet "dist" } "." } ;

ARTICLE: "om.series" "om.series"
"The " { $vocab-link "om.series" } " vocabulary is an experimental port of the file " { $snippet "projects/01-basicproject/functions/series.lisp" } " from the main " { $snippet "code" } " tree of OpenMusic."
$nl
"The text in descriptions and notes was copied verbatim from the original docstrings.  There may be little or no meaning left in it after the transfer." ;

ABOUT: "om.series"
