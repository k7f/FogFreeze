! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.sets help.markup help.syntax kernel math math.functions
       om.help.markup om.syntax quotations sequences words.symbol ;
QUALIFIED: sets
IN: om.support

HELP: unpack1
{ $values
  { "&optionals" { $optionals } }
  { "arg1/f" object }
}
{ $description "Used for unpacking a single " { $snippet "&optional" } " parameter." }
{ $see-also unpack1* unpack2 unpack3 "lisp-alikes" } ;

HELP: unpack1*
{ $values
  { "&optionals" { $optionals } }
  { "quot"  { $quotation "( -- arg1/f )" } }
}
{ $description "Used for unpacking a single " { $snippet "&optional" } " parameter." }
{ $notes { $unpacking-combinator unpack1 } }
{ $see-also unpack1 unpack2* unpack3* "lisp-alikes" } ;

HELP: unpack2
{ $values
  { "&optionals" { $optionals } }
  { "arg1-default" object }
  { "arg1" object }
  { "arg2/f" object }
}
{ $description "Used for unpacking two " { $snippet "&optional" } " parameters." }
{ $see-also unpack2* unpack1 unpack3 "lisp-alikes" } ;

HELP: unpack2*
{ $values
  { "&optionals" { $optionals } }
  { "arg1-default" object }
  { "quot"  { $quotation "( -- arg1 arg2/f )" } }
}
{ $description "Used for unpacking two " { $snippet "&optional" } " parameters." }
{ $notes { $unpacking-combinator unpack2 } }
{ $see-also unpack2 unpack1* unpack3* "lisp-alikes" } ;

HELP: unpack3
{ $values
  { "&optionals" { $optionals } }
  { "arg1-default" object }
  { "arg2-default" object }
  { "arg1" object }
  { "arg2" object }
  { "arg3/f" object }
}
{ $description "Used for unpacking three " { $snippet "&optional" } " parameters." }
{ $see-also unpack3* unpack1 unpack2 "lisp-alikes" } ;

HELP: unpack3*
{ $values
  { "&optionals" { $optionals } }
  { "arg1-default" object }
  { "arg2-default" object }
  { "quot"  { $quotation "( -- arg1 arg2 arg3/f )" } }
}
{ $description "Used for unpacking three " { $snippet "&optional" } " parameters." }
{ $notes { $unpacking-combinator unpack3 } }
{ $see-also unpack3 unpack1* unpack2* "lisp-alikes" } ;

HELP: unpack-test&key
{ $values
  { "&optionals" { $optionals } }
  { "test-default" { $quotation "( obj1 obj2 -- ? )" } }
  { "quot" { $quotation "( -- quot: ( obj1 obj2 -- ? ) )" } }
}
{ $description "Used for unpacking two " { $snippet "&optional" } " parameters: a binary predicate and a unary operator, and composing them into a single quotation." }
{ $see-also at-test&key "lisp-alikes" } ;

HELP: at-test&key
{ $values
  { "&keys" { $keys } }
  { "test-default" { $quotation "( obj1 obj2 -- ? )" } }
  { "quot" { $quotation "( obj1 obj2 -- ? )" } }
}
{ $description "Used for unpacking two " { $snippet "&key" } " parameters: " { $link :test } " and " { $link :key } ", and composing them into a single quotation." }
{ $see-also unpack-test&key "lisp-alikes" } ;

HELP: &rest>sequence
{ $values
  { "&rest" { $rest } }
  { "seq/f" "a " { $link sequence } " or an " { $link f } }
}
{ $description "Outputs a sequence of arguments corresponding to a " { $snippet "&rest" } " parameter specifier." }
{ $see-also "lisp-alikes" } ;

HELP: om-binop-number
{ $values
  { "quot" { $quotation "( elt1 elt2 -- elt' )" } }
  { "quot" quotation }
}
{ $description "A factory yielding " { $link number } "\u{medium-white-circle}" { $link number } " and " { $link sequence } "\u{medium-white-circle}" { $link number } " binary operators." } ;

HELP: om-binop-sequence
{ $values
  { "quot" { $quotation "( elt1 elt2 -- elt' )" } }
  { "quot" quotation }
}
{ $description "A factory yielding " { $link number } "\u{medium-white-circle}" { $link sequence } " and " { $link sequence } "\u{medium-white-circle}" { $link sequence } " binary operators." } ;

HELP: cl-symbol
{ $var-description "A non-executable variant of " { $link symbol } "." }
{ $see-also "lisp-alikes" } ;

HELP: cl-floor
{ $values
  { "num" real }
  { "div" real }
  { "quo" integer }
  { "rem" real }
}
{ $description "A variant of " { $link floor } "." }
{ $see-also "lisp-alikes" } ;

HELP: cl-ceiling
{ $values
  { "num" real }
  { "div" real }
  { "quo" integer }
  { "rem" real }
}
{ $description "A variant of " { $link ceiling } "." }
{ $see-also "lisp-alikes" } ;

HELP: cl-truncate
{ $values
  { "num" real }
  { "div" real }
  { "quo" integer }
  { "rem" real }
}
{ $description "A variant of " { $link truncate } "." }
{ $see-also "lisp-alikes" } ;

HELP: cl-round
{ $values
  { "num" real }
  { "div" real }
  { "quo" integer }
  { "rem" real }
}
{ $description "A variant of " { $link round } "." }
{ $see-also "lisp-alikes" } ;

HELP: cl-identity
{ $values
  { "obj" object }
  { "obj" object }
}
{ $description "Outputs its argument, unchanged." } ;

ARTICLE: "lisp-alikes" "Lisp-alikes"
"Factor replacements and implementation helpers used for porting Common Lisp constructs:"
$nl
{ $table
  { " Common Lisp construct" " Factor replacement" " Factor implementation helpers" " Common Lisp documentation" }
  { { "keyword " { $snippet "&optional" } } { } { $links unpack1 unpack1* unpack2 unpack2* unpack3 unpack3* unpack-test&key } { $clhs-link "03_dab.htm" } }
  { { "keyword " { $snippet "&key" } } { } { $links at-test&key } { $clhs-link "03_dad.htm" } }
  { { "keyword " { $snippet "&rest" } } { } { $link &rest>sequence } { $clhs-link "03_dac.htm" } }
  { { "quoted list expression " { $snippet "'(...)" } } { $link POSTPONE: '( } { } { $clhs-link "02_dc.htm" } }
  { { "system class " { $snippet "SYMBOL" } } { $link cl-symbol } { } { $clhs-link "t_symbol.htm" } }
  { { "function " { $snippet "identity" } } { $link cl-identity } { } { $clhs-link "f_identi.htm" } }
  { { "function " { $snippet "remove-duplicates" } " with " { $snippet ":test" } " argument" } { $link members* } { } { $clhs-link "f_rm_dup.htm" } }
  { { "function " { $snippet "union" } " with " { $snippet ":test" } " argument" } { $link union* } { } { $clhs-link "f_unionc.htm" } }
  { { "function " { $snippet "intersection" } " with " { $snippet ":test" } " argument" } { $link intersect* } { } { $clhs-link "f_isec_.htm" } }
  { { "function " { $snippet "set-difference" } " with " { $snippet ":test" } " argument" } { $link diff* } { } { $clhs-link "f_set_di.htm" } }
  { { "function " { $snippet "set-exclusive-or" } " with " { $snippet ":test" } " argument" } { $link symmetric-diff* } { } { $clhs-link "f_set_ex.htm" } }
{ { "function " { $snippet "subsetp" } " with " { $snippet ":test" } " argument" } { $link subset*? } { } { $clhs-link "f_subset.htm" } }
  { { "function " { $snippet "floor" } } { $link cl-floor } { } { $clhs-link "f_floorc.htm" } }
  { { "function " { $snippet "ceiling" } } { $link cl-ceiling } { } { $clhs-link "f_floorc.htm" } }
  { { "function " { $snippet "truncate" } } { $link cl-truncate } { } { $clhs-link "f_floorc.htm" } }
  { { "function " { $snippet "round" } } { $link cl-round } { } { $clhs-link "f_floorc.htm" } }
} ;

ARTICLE: "om.support" "om.support"
"The " { $vocab-link "om.support" } " vocabulary supplies the \"om\" tree of vocabularies with various helper words (among others, " { $link "lisp-alikes" } " \u{em-dash} replacements for Common Lisp constructs)."
{ $see-also "lisp-alikes" } ;

ABOUT: "om.support"
