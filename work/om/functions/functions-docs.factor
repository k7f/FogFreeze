! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.help.markup help.markup help.syntax kernel math om.bpf
       om.help.markup om.help.reference ;
IN: om.functions

HELP: linear-fun
{ $values
  { "x0" number }
  { "y0" number }
  { "x1" number }
  { "y1" number }
  { "quot" { $quotation "( x -- y )" } }
}
{ $description "Constructs a linear function passing through the points (x0 y0) and (x1 y1)."
  $nl
  "The resulting function can be connected for example to SAMPLEFUN." }
  { $notes "In a special case of x0 being equal x1, the output function's values are all 0 except at point x0, where the function evaluates to 1." } ;

HELP: y-transfer
{ $values
  { "obj" object }
  { "y" number }
  { "&optionals" { $optionals } }
  { "x-values" { $sequence-of number } }
}
{ $optional-defaults
  { "dec" POSTPONE: f }
}
{ $description "Returns a list of interpolated X values corresponding to a list of points ((x1 y1) (x2 y2) ...), or a BPF/BPC (" { $snippet "self" } ") and a Y position " { $snippet "y0" } "."
  $nl
  "Optional " { $snippet "dec" } " is the number of decimals in the result." } ;

HELP: x-transfer
{ $values
  { "obj" object }
  { "x-values" { $class/sequence-of number } }
  { "&optionals" { $optionals } }
  { "y-values" { $sequence-of number } }
}
{ $optional-defaults
  { "dec" POSTPONE: f }
}
{ $description "Returns the interpolated Y value(s) in a BPF or a list ((x1 y1) (x2 y2) ...) corresponding to an X value or a list of X values (" { $snippet "x-val" } ")."
  $nl
  "Optional " { $snippet "dec" } " is the number of decimals in the result." } ;

HELP: om-sample
{ $values
  { "obj" object }
  { "count/step" "a non-negative " { $link integer } " or a positive " { $link float } }
  { "&optionals" { $optionals } }
  { "bpf" bpf }
  { "xs" { $sequence-of number } }
  { "ys" { $sequence-of number } }
}
{ $optional-defaults
  { "xmin" POSTPONE: f }
  { "xmax" POSTPONE: f }
  { "dec" POSTPONE: f }
}
{ $description "Resamples a function, a list, a BPF or a BPC object."
  $nl
  "Returns :\n"
  " - The result as an object (BPF or BPC) (1st output)\n"
  " - The list of x points (2nd output)\n"
  " - The list of sample values (3rd output)"
  $nl
  "If " { $snippet "nbs-sr" } " is an integer (e.g. 100) it is interpreted as the number of samples to be returned"
  $nl
  "If " { $snippet "nbs-sr" } " is an float (e.g. 0.5, 1.0...) it is interpreted as the sample rate (or step between two samples) of the function to return"
  $nl
  { $snippet "xmin" } " and " { $snippet "xmax" } " allow to specify the x-range to resample."
  $nl
  { $snippet "dec" } " (decimals) is the precision of the result"
}
{ $moving-target
  { $list
    { "The optional argument " { $snippet "dec" } " is ignored." }
    { "This version, compatibly, excludes upper boundary when " { $snippet "xmax" } " is specified in by-count mode \u{em-dash} which might be just an off-by-one bug..." }
  }
} ;

OM-REFERENCE:
"projects/01-basicproject/functions/functions.lisp"
{ "linear-fun" linear-fun }
{ "y-transfer" y-transfer }
{ "x-transfer" x-transfer }
{ "om-sample" om-sample } ;

ARTICLE: "om.functions" "om.functions"
{ $vocab-intro "om.functions" "projects/01-basicproject/functions/functions.lisp" } ;

ABOUT: "om.functions"
