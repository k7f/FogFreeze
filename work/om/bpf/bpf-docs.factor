! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.help.markup arrays help.markup help.syntax kernel math
       om.graphics om.help.markup sequences ;
IN: om.bpf

HELP: internal-bpf
{ $var-description "" } ;

HELP: <internal-bpf>
{ $values
  { "n" "a non-negative " { $link integer } }
  { "ibpf" bpf }
}
{ $description "" } ;

HELP: bpf
{ $var-description "" } ;

HELP: <bpf>
{ $values
  { "n" "a non-negative " { $link integer } }
  { "bpf" bpf }
}
{ $description "" } ;

HELP: point-pairs
{ $values
  { "bpf" bpf }
  { "pairs" "an " { $link array } " of pairs of " { $link number } "s" }
}
{ $description "Returns the list of points in " { $snippet "self" } " as a list ((x1 y1) (x2 y2) ...)." } ;

HELP: cons-bpf
{ $values
  { "points" "a " { $link sequence } " of " { $link om-point } "s" }
  { "obj" object }
}
{ $description "" } ;

HELP: simple-bpf-from-list
{ $values
  { "xs" "a " { $link real } " or a " { $link sequence } " of " { $link real } "s" }
  { "ys" "a " { $link real } " or a " { $link sequence } " of " { $link real } "s" }
  { "&optionals" { $optionals } }
  { "bpf" bpf }
}
{ $optional-defaults
  { "class" { $link bpf } }
  { "decimals" { $snippet "0" } }
}
{ $description "" }
{ $notes
  { $list
    { "If " { $snippet "xs" } " and " { $snippet "ys" } " are nonempty sequences of different lengths, the resulting sequence contains the same number of points as the longer input (missing values are generated by simple extrapolation)." }
    { "If " { $snippet "xs" } " is a number and " { $snippet "ys" } " is a sequence, then the x-coordinate of the first point in the resulting sequence is set to 0, and it is incremented for subsequent points by " { $snippet "xs" } "." }
  }
}
{ $moving-target "The optional argument " { $snippet "decimals" } " is ignored." } ;

ARTICLE: "om.bpf" "om.bpf"
{ $vocab-intro "om.bpf" "projects/01-basicproject/classes/bpf.lisp" } ;

ABOUT: "om.bpf"
