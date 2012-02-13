! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: help.markup help.syntax kernel math om.graphics om.help.markup
       sequences ;
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
{ $description "" } ;

ARTICLE: "om.bpf" "om.bpf"
{ $vocab-intro "om.bpf" "projects/01-basicproject/classes/bpf.lisp" } ;

ABOUT: "om.bpf"
