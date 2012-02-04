! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: arrays combinators help.markup help.syntax kernel math math.functions
       om.help.markup quotations sequences sequences.deep words words.symbol ;
QUALIFIED: sets
IN: om.support

HELP: unpack1
{ $values
  { "&optionals" { $optionals } }
  { "arg1/f" object }
}
{ $description "Used for unpacking a single " { $snippet "&optional" } " parameter." }
{ $see-also unpack2 unpack3 "lisp-alikes" } ;

HELP: unpack2
{ $values
  { "&optionals" { $optionals } }
  { "arg1-default" object }
  { "arg1" object }
  { "arg2/f" object }
}
{ $description "Used for unpacking two " { $snippet "&optional" } " parameters." }
{ $see-also unpack1 unpack3 "lisp-alikes" } ;

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
{ $see-also unpack1 unpack2 "lisp-alikes" } ;

HELP: &keys:test:key>quotation
{ $values
  { "&keys" { $keys } }
  { "quot" { $quotation "( obj1 obj2 -- ? )" } }
}
{ $description "Used for unpacking two " { $snippet "&key" } " parameters, " { $snippet ":test" } " and " { $snippet ":key" } ", and composing them into a single quotation." }
{ $see-also "lisp-alikes" } ;

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

HELP: deep-reduce
{ $values
  { "obj" object }
  { "identity" object }
  { "quot" { $quotation "( ..a prev elt -- ..b next )" } }
  { "result" object }
}
{ $description "Traverses nested elements of an object, in preorder, combines successively visited elements using a binary operation, and outputs the final result." }
{ $see-also reduce } ;

HELP: deep-filter-leaves
{ $values
  { "obj" object }
  { "quot" { $quotation "( ..a elt -- ..b ? )" } }
  { "seq" sequence }
}
{ $description "Like " { $link deep-filter } ", but operates only on non-branching elements of an object." } ;

HELP: deep-map-leaves
{ $values
  { "obj" object }
  { "quot" { $quotation "( ..a elt -- ..b elt' )" } }
  { "newobj" object }
}
{ $description "Like " { $link deep-map } ", but operates only on non-branching elements of an object." } ;

HELP: filter-as-index
{ $values
  { "seq" sequence }
  { "quot" { $quotation "( ..a elt ndx -- ..b ? )" } }
  { "exemplar" object }
  { "seq'" sequence }
}
{ $description "Like " { $link filter-as } ", but the quotation takes both, element " { $emphasis "and" } " its index, similarly to " { $link each-index } "." } ;

HELP: filter-index
{ $values
  { "seq" sequence }
  { "quot" { $quotation "( ..a elt ndx -- ..b ? )" } }
  { "seq'" sequence }
}
{ $description "Like " { $link filter } ", but the quotation takes both, element " { $emphasis "and" } " its index, similarly to " { $link each-index } "." } ;

HELP: filter-as/indices
{ $values
  { "seq" sequence }
  { "quot" { $quotation "( ..a elt -- ..b ? )" } }
  { "exemplar" object }
  { "seq'" sequence }
}
{ $description "Like " { $link filter-as } ", but outputs a sequence of element indices, not the elements themselves." } ;

HELP: filter/indices
{ $values
  { "seq" sequence }
  { "quot" { $quotation "( ..a elt -- ..b ? )" } }
  { "seq'" sequence }
}
{ $description "Like " { $link filter } ", but outputs a sequence of element indices, not the elements themselves." } ;

HELP: accumulate-all-as
{ $values
  { "seq" sequence }
  { "identity" object }
  { "quot" { $quotation "( ..a prev elt -- ..b next )" } }
  { "exemplar" object }
  { "newseq" sequence }
}
{ $description "Like " { $link accumulate-as } ", but stores all steps (including final result) in the output sequence." } ;

HELP: accumulate-all
{ $values
  { "seq" sequence }
  { "identity" object }
  { "quot" { $quotation "( ..a prev elt -- ..b next )" } }
  { "newseq" sequence }
}
{ $description "Like " { $link accumulate } ", but stores all steps (including final result) in the output sequence." } ;

HELP: fixed-any?
{ $values
  { "seq" sequence }
  { "quot" quotation }
  { "?" boolean }
}
$ad-hoc-monomorphic
{ $see-also any? } ;

HELP: fixed-deep-each
{ $values
  { "obj" object }
  { "quot" quotation }    
}
$ad-hoc-monomorphic
{ $see-also deep-each } ;

HELP: fixed-deep-filter
{ $values
  { "obj" object }
  { "quot" quotation }
  { "seq" sequence }
}
$ad-hoc-monomorphic
{ $see-also deep-filter } ;

HELP: fixed-deep-filter-leaves
{ $values
  { "obj" object }
  { "quot" quotation }
  { "seq" sequence }
}
$ad-hoc-monomorphic
{ $see-also deep-filter-leaves } ;

HELP: fixed-deep-reduce
{ $values
  { "obj" object }
  { "identity" object }
  { "quot" quotation }
  { "result" object }
}
$ad-hoc-monomorphic
{ $see-also deep-reduce } ;

HELP: fixed-filter
{ $values
  { "seq" sequence }
  { "quot" quotation }
  { "seq'" sequence }
}
$ad-hoc-monomorphic
{ $see-also filter } ;

HELP: fixed-filter-as
{ $values
  { "seq" sequence }
  { "quot" quotation }
  { "exemplar" object }
  { "seq'" sequence }
}
$ad-hoc-monomorphic 
{ $see-also filter-as } ;

HELP: fixed-filter-as/indices
{ $values
  { "seq" sequence }
  { "quot" quotation }
  { "exemplar" object }
  { "seq'" sequence }
}
$ad-hoc-monomorphic
{ $see-also filter-as/indices } ;

HELP: fixed-filter/indices
{ $values
  { "seq" sequence }
  { "quot" quotation }
  { "seq'" sequence }
}
$ad-hoc-monomorphic
{ $see-also filter/indices } ;

HELP: fixed-find
{ $values
  { "seq" sequence }
  { "quot" quotation }
  { "i" object }
  { "elt" object }
}
$ad-hoc-monomorphic
{ $see-also find } ;

HELP: fixed1-each-integer
{ $values
  { "a" object }
  { "n" object }
  { "quot" quotation }
  { "a'" object }
}
$ad-hoc-monomorphic
{ $see-also each-integer } ;

HELP: fixed1-filter-as-index
{ $values
  { "a" object }
  { "seq" sequence }
  { "quot" quotation }
  { "exemplar" object }
  { "b" object }
  { "seq'" sequence }
}
$ad-hoc-monomorphic
{ $see-also filter-as-index } ;

HELP: fixed1-filter-index
{ $values
  { "a" object }
  { "seq" sequence }
  { "quot" quotation }
  { "b" object }
  { "seq'" sequence }
}
$ad-hoc-monomorphic
{ $see-also filter-index } ;

HELP: fixed1-times
{ $values
  { "a" object }
  { "n" object }
  { "quot" quotation }
  { "a'" object }
}
$ad-hoc-monomorphic
{ $see-also times } ;

HELP: fixed2-each-integer
{ $values
  { "a" object }
  { "b" object }
  { "n" object }
  { "quot" quotation }
  { "a'" object }
  { "b'" object }
}
$ad-hoc-monomorphic
{ $see-also each-integer } ;

HELP: fixed2-times
{ $values
  { "a" object }
  { "b" object }
  { "n" object }
  { "quot" quotation }
  { "a'" object }
  { "b'" object }
}
$ad-hoc-monomorphic
{ $see-also times } ;

HELP: fixed3-map!
{ $values
  { "a" object }
  { "b" object }
  { "c" object }
  { "seq" sequence }
  { "quot" quotation }    
}
$ad-hoc-monomorphic
{ $see-also map! } ;

HELP: sum-lengths-with-atoms
{ $values
    { "seq" sequence }
    { "n" integer }
}
{ $description "Like " { $link sum-lengths } ", but accepts atoms as valid elements of length 1, instead of raising an error." } ;

HELP: members*
{ $values
  { "seq" sequence }
  { "quot" { $quotation "( obj1 obj2 -- ? )" } }
  { "seq'" sequence }
}
{ $description "Like " { $link sets:members } ", but equality test may be arbitrary, instead of the hard-coded " { $link = } " operator." }
{ $see-also "lisp-alikes" } ;

HELP: set-like*
{ $values
  { "seq" sequence }
  { "quot" { $quotation "( obj1 obj2 -- ? )" } }
  { "exemplar" sets:set }
  { "set" sets:set }
}
{ $description "Like " { $link sets:set-like } ", but equality test may be arbitrary, instead of the hard-coded " { $link = } " operator." } ;

HELP: union*
{ $values
  { "seq1" sequence }
  { "seq2" sequence }
  { "quot" { $quotation "( obj1 obj2 -- ? )" } }
  { "seq'" sequence }
}
{ $description "Like " { $link sets:union } ", but equality test may be arbitrary, instead of the hard-coded " { $link = } " operator." }
{ $see-also "lisp-alikes" } ;

HELP: subset*?
{ $values
  { "seq1" sequence }
  { "seq2" sequence }
  { "quot" { $quotation "( obj1 obj2 -- ? )" } }
  { "?" boolean }
}
{ $description "Like " { $link sets:subset? } ", but equality test may be arbitrary, instead of the hard-coded " { $link = } " operator." }
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
{ $description "Outputs the tail of " { $snippet "seq" } " starting from the first " { $snippet "seq" } "'s element found in " { $snippet "candidates" } "." }
{ $see-also find-tail* } ;

HELP: find-tail*
{ $values
  { "seq" sequence }
  { "candidates" sequence }
  { "tailseq/f" "a " { $link sequence } " or an " { $link f } }
}
{ $description "Outputs the tail of " { $snippet "seq" } " starting from the first occurence of the first such element of " { $snippet "candidates" } ", that is also contained in " { $snippet "seq" } "." }
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
  { { "keyword " { $snippet "&optional" } } { } { $links unpack1 unpack2 unpack3 } { $clhs-link "03_dab.htm" } }
  { { "keyword " { $snippet "&key" } } { } { $link &keys:test:key>quotation } { $clhs-link "03_dad.htm" } }
  { { "keyword " { $snippet "&rest" } } { } { $link &rest>sequence } { $clhs-link "03_dac.htm" } }
  { { "quoted list expression " { $snippet "'(...)" } } { $link POSTPONE: '( } { } { $clhs-link "02_dc.htm" } }
  { { "system class " { $snippet "SYMBOL" } } { $link cl-symbol } { } { $clhs-link "t_symbol.htm" } }
  { { "function " { $snippet "identity" } } { $link cl-identity } { } { $clhs-link "f_identi.htm" } }
  { { "function " { $snippet "remove-duplicates" } " with " { $snippet ":test" } " argument" } { $link members* } { } { $clhs-link "f_rm_dup.htm" } }
  { { "function " { $snippet "union" } " with " { $snippet ":test" } " argument" } { $link union* } { } { $clhs-link "f_unionc.htm" } }
  { { "function " { $snippet "subsetp" } " with " { $snippet ":test" } " argument" } { $link subset*? } { } { $clhs-link "f_subset.htm" } }
  { { "function " { $snippet "floor" } } { $link cl-floor } { } { $clhs-link "f_floorc.htm" } }
} ;

ARTICLE: "om.support" "om.support"
"The " { $vocab-link "om.support" } " vocabulary supplies the \"om\" tree of vocabularies with various helper words (among others, " { $link "lisp-alikes" } " \u{em-dash} replacements for Common Lisp constructs)."
$ad-hoc-monomorphic
{ $see-also "lisp-alikes" } ;

ABOUT: "om.support"
