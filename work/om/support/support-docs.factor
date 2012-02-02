! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: arrays combinators help.markup help.syntax kernel math math.functions
       quotations sequences words words.symbol ;
QUALIFIED: sets
IN: om.support

HELP: unpack1
{ $values
  { "&optionals" object }
  { "arg1/f" object }
}
{ $description "" }
{ $see-also "lisp-alikes" } ;

HELP: unpack2
{ $values
  { "&optionals" object }
  { "arg1-default" object }
  { "arg1" object }
  { "arg2/f" object }
}
{ $description "" }
{ $see-also "lisp-alikes" } ;

HELP: unpack3
{ $values
  { "&optionals" object }
  { "arg1-default" object }
  { "arg2-default" object }
  { "arg1" object }
  { "arg2" object }
  { "arg3/f" object }
}
{ $description "" }
{ $see-also "lisp-alikes" } ;

HELP: &rest>sequence
{ $values
  { "obj" object }
  { "seq/f" "a " { $link sequence } " or an " { $link f } }
}
{ $description "Used for unpacking " { $snippet "&rest" } " parameter specifier." }
{ $see-also "lisp-alikes" } ;

HELP: om-binop-number
{ $values
  { "quot" quotation }
  { "quot" quotation }
}
{ $description "A factory yielding " { $link number } "\u{medium-white-circle}" { $link number } " and " { $link sequence } "\u{medium-white-circle}" { $link number } " binary operators." } ;

HELP: om-binop-sequence
{ $values
  { "quot" quotation }
  { "quot" quotation }
}
{ $description "A factory yielding " { $link number } "\u{medium-white-circle}" { $link sequence } " and " { $link sequence } "\u{medium-white-circle}" { $link sequence } " binary operators." } ;

HELP: deep-filter-leaves
{ $values
  { "obj" object }
  { "quot" quotation }
  { "seq" sequence }
}
{ $description "" } ;

HELP: deep-map-leaves
{ $values
  { "obj" object }
  { "quot" quotation }
  { "newobj" object }
}
{ $description "" } ;

HELP: deep-reduce
{ $values
  { "seq" sequence }
  { "identity" object }
  { "quot" quotation }
  { "result" object }
}
{ $description "" } ;

HELP: filter-as-index
{ $values
  { "seq" sequence }
  { "quot" quotation }
  { "exemplar" object }
  { "seq'" sequence }
}
{ $description "" } ;

HELP: filter-as/indices
{ $values
  { "seq" sequence }
  { "quot" quotation }
  { "exemplar" object }
  { "seq'" sequence }
}
{ $description "" } ;

HELP: filter-index
{ $values
  { "seq" sequence }
  { "quot" quotation }
  { "seq'" sequence }
}
{ $description "" } ;

HELP: filter/indices
{ $values
  { "seq" sequence }
  { "quot" quotation }
  { "seq'" sequence }
}
{ $description "" } ;

HELP: fixed-any?
{ $values
  { "seq" sequence }
  { "quot" quotation }
  { "?" boolean }
}
{ $description "" } ;

HELP: fixed-deep-each
{ $values
  { "obj" object }
  { "quot" quotation }    
}
{ $description "" } ;

HELP: fixed-deep-filter
{ $values
  { "obj" object }
  { "quot" quotation }
  { "seq" sequence }
}
{ $description "" } ;

HELP: fixed-deep-filter-leaves
{ $values
  { "obj" object }
  { "quot" quotation }
  { "seq" sequence }
}
{ $description "" } ;

HELP: fixed-deep-reduce
{ $values
  { "seq" sequence }
  { "identity" object }
  { "quot" quotation }
  { "result" object }
}
{ $description "" } ;

HELP: fixed-filter
{ $values
  { "seq" sequence }
  { "quot" quotation }
  { "seq'" sequence }
}
{ $description "" } ;

HELP: fixed-filter-as
{ $values
  { "seq" sequence }
  { "quot" quotation }
  { "exemplar" object }
  { "seq'" sequence }
}
{ $description "" } ;

HELP: fixed-filter-as/indices
{ $values
  { "seq" sequence }
  { "quot" quotation }
  { "exemplar" object }
  { "seq'" sequence }
}
{ $description "" } ;

HELP: fixed-filter/indices
{ $values
  { "seq" sequence }
  { "quot" quotation }
  { "seq'" sequence }
}
{ $description "" } ;

HELP: fixed-find
{ $values
  { "seq" sequence }
  { "quot" quotation }
  { "i" object }
  { "elt" object }
}
{ $description "" } ;

HELP: fixed1-each-integer
{ $values
  { "a" object }
  { "n" object }
  { "quot" quotation }
  { "a'" object }
}
{ $description "" } ;

HELP: fixed1-filter-as-index
{ $values
  { "a" object }
  { "seq" sequence }
  { "quot" quotation }
  { "exemplar" object }
  { "b" object }
  { "seq'" sequence }
}
{ $description "" } ;

HELP: fixed1-filter-index
{ $values
  { "a" object }
  { "seq" sequence }
  { "quot" quotation }
  { "b" object }
  { "seq'" sequence }
}
{ $description "" } ;

HELP: fixed1-times
{ $values
  { "a" object }
  { "n" object }
  { "quot" quotation }
  { "a'" object }
}
{ $description "" } ;

HELP: fixed2-each-integer
{ $values
  { "a" object }
  { "b" object }
  { "n" object }
  { "quot" quotation }
  { "a'" object }
  { "b'" object }
}
{ $description "" } ;

HELP: fixed2-times
{ $values
  { "a" object }
  { "b" object }
  { "n" object }
  { "quot" quotation }
  { "a'" object }
  { "b'" object }
}
{ $description "" } ;

HELP: fixed3-map!
{ $values
  { "a" object }
  { "b" object }
  { "c" object }
  { "seq" sequence }
  { "quot" quotation }    
}
{ $description "" } ;

HELP: accumulate-all
{ $values
  { "seq" sequence }
  { "identity" object }
  { "quot" quotation }
  { "newseq" sequence }
}
{ $description "Like " { $link accumulate } ", but stores all steps, including final result, in the returned sequence." } ;

HELP: accumulate-all-as
{ $values
  { "seq" sequence }
  { "identity" object }
  { "quot" quotation }
  { "exemplar" object }
  { "newseq" sequence }
}
{ $description "Like " { $link accumulate-as } ", but stores all steps, including final result, in the returned sequence." } ;

HELP: sum-lengths-with-atoms
{ $values
    { "seq" sequence }
    { "n" integer }
}
{ $description "Like " { $link sum-lengths } ", but accepts atoms as valid elements of length 1, instead of raising an error." } ;

HELP: members*
{ $values
  { "seq" sequence }
  { "quot" quotation }
  { "seq'" sequence }
}
{ $description "A variant of " { $link sets:members } "." }
{ $see-also "lisp-alikes" } ;

HELP: >power-of-2
{ $values
  { "m" "a non-negative " { $link integer } }
  { "n" integer }
}
{ $description "Like " { $link next-power-of-2 } ", but rounding down, not up." } ;

HELP: cl-floor
{ $values
  { "num" real }
  { "div" real }
  { "quo" integer }
  { "rem" real }
}
{ $description "A variant of " { $link floor } "." }
{ $see-also "lisp-alikes" } ;

HELP: find-tail
{ $values
  { "seq" sequence }
  { "candidates" sequence }
  { "tailseq/f" "a " { $link sequence } " or an " { $link f } }
}
{ $description "Returns the tail of " { $snippet "seq" } " starting from first " { $snippet "seq" } " element in " { $snippet "candidates" } "." }
{ $see-also find-tail* } ;

HELP: find-tail*
{ $values
  { "seq" sequence }
  { "candidates" sequence }
  { "tailseq/f" "a " { $link sequence } " or an " { $link f } }
}
{ $description "Returns the tail of " { $snippet "seq" } " starting from first occurence of first element of " { $snippet "candidates" } " in " { $snippet "seq" } "." }
{ $see-also find-tail } ;

HELP: cl-symbol
{ $var-description "A non-executable variant of " { $link symbol } "." }
{ $see-also "lisp-alikes" } ;

HELP: '(
{ $description "Starts a literal " { $link array } ", which has to be terminated with closing parenthesis: " { $snippet ")" } ".  This is similar to " { $link POSTPONE: { } ", but " { $link word } "s inside parens are converted to " { $link cl-symbol } "s."
$nl
{ $snippet "()" } "-arrays may be nested.  However, internal opening parentheses should be left unescaped: those with leading " { $snippet "'" } "s will be converted to " { $link cl-symbol } "s ." }
{ $notes "Not converted are two parsing words: " { $link POSTPONE: " } " and " { $link POSTPONE: CHAR: } "." }
{ $see-also "lisp-alikes" } ;

ARTICLE: "lisp-alikes" "Lisp-alikes"
"Factor replacements and implementation helpers used for porting Common Lisp constructs:"
$nl
{ $table
  { " Common Lisp construct" " Factor replacement" " Factor implementation helpers" " Common Lisp documentation" }
  { { "keyword " { $snippet "&optional" } } { } { $links unpack1 unpack2 unpack3 } { $url "clhs.lisp.se/Body/03_dab.htm" } }
  { { "keyword " { $snippet "&rest" } } { } { $link &rest>sequence } { $url "clhs.lisp.se/Body/03_dac.htm" } }
  { { "quoted list expression " { $snippet "'(...)" } } { $link POSTPONE: '( } { } { $url "clhs.lisp.se/Body/02_dc.htm" } }
  { { "system class " { $snippet "SYMBOL" } } { $link cl-symbol } { } { $url "clhs.lisp.se/Body/t_symbol.htm" } }
  { { "function " { $snippet "remove-duplicates" } " with " { $snippet ":test" } " argument" } { $link members* } { } { $url "clhs.lisp.se/Body/f_rm_dup.htm" } }
  { { "function " { $snippet "floor" } } { $link cl-floor } { } { $url "clhs.lisp.se/Body/f_floorc.htm" } }
} ;

ARTICLE: "om.support" "om.support"
"The " { $vocab-link "om.support" } " vocabulary supplies the \"om\" tree of vocabularies with various helper words (among others, " { $link "lisp-alikes" } " \u{em-dash} replacements for Common Lisp constructs)."
{ $warning "Ad-hoc definitions of monomorphic combinators will (hopefully) be replaced with generic macros or some other mechanism (e.g. " { $link call-effect } " with run-time stack-effect resolution)." }
{ $see-also "lisp-alikes" } ;

ABOUT: "om.support"
