! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.help.markup arrays help.markup help.syntax kernel math
       math.constants math.order om.help.markup sequences words.symbol ;
IN: om.kernel

[!use-om-reference]

HELP: om+
{ $values
  { "obj1" { $class/sequence-of number } }
  { "obj2" { $class/sequence-of number } }
  { "result" { $class/sequence-of number } }
}
{ $description "Sum of two numbers or lists." } ;

HELP: om*
{ $values
  { "obj1" { $class/sequence-of number } }
  { "obj2" { $class/sequence-of number } }
  { "result" { $class/sequence-of number } }
}
{ $description "Product of two numbers or lists." } ;

HELP: om-
{ $values
  { "obj1" { $class/sequence-of number } }
  { "obj2" { $class/sequence-of number } }
  { "result" { $class/sequence-of number } }
}
{ $description "Difference of two numbers or lists." } ;

HELP: om/
{ $values
  { "obj1" { $class/sequence-of number } }
  { "obj2" { $class/sequence-of number } }
  { "result" { $class/sequence-of number } }
}
{ $description "Division of two  numbers or lists." } ;

HELP: om^
{ $values
  { "obj1" { $class/sequence-of number } }
  { "obj2" { $class/sequence-of number } }
  { "result" { $class/sequence-of number } }
}
{ $description "Exponentiation of base a and exponent b." } ;

HELP: om-e
{ $values
  { "obj" { $class/sequence-of number } }
  { "result" { $class/sequence-of number } }
}
{ $description "Exponential function." }
{ $notes "This function can be applied on numbers or lists." } ;

HELP: om-log
{ $values
  { "obj" { $class/sequence-of number } }
  { "&optionals" { $optionals } }
  { "result" { $class/sequence-of number } }
}
{ $optional-defaults
  { "base" "the number " { $link e } }
}
{ $description "Logarithm function.  (The logarithm of a number to the base is the power to which the base must be raised in order to produce the number.)" }
{ $notes "The " { $snippet "base" } " argument is optional.  By default, " { $snippet "base" } " is equal to the number " { $emphasis "e" } ", so " { $snippet "om-log" } " computes the " { $emphasis "natural" } " logarithm of " { $snippet "n" } "."
  $nl
  "This function can be applied on numbers or lists." } ;

HELP: om-round
{ $values
  { "obj" object }
  { "&optionals" { $optionals } }
  { "obj'" object }
}
{ $optional-defaults
  { "num-decimals" { $snippet "0" } }
  { "divisor" { $snippet "1" } }
}
{ $description "Rounds a number or a list of numbers with a given number of decimals (default = 0, i.e. returns integer values) and a divisor." }
{ $notes "This function can be applied to numbers or lists." } ;

HELP: om//
{ $values
  { "obj" object }
  { "div" object }
  { "quo" object }
  { "rem" object }
}
{ $description "Euclidean division of " { $snippet "n" } " and " { $snippet "divisor" } ". Yields an integer result and the rest of the division.  When the divisor is 1, the operation is known as " { $emphasis "floor" } "." }
{ $notes { $snippet "n" } " and " { $snippet "divisor" } " can be numbers or lists." } ;

HELP: om-abs
{ $values
  { "obj" object }
  { "result" object }
}
{ $description "Absolute value." }
{ $notes "This function can be applied to numbers or lists." } ;

HELP: om-min
{ $values
  { "obj1" object }
  { "obj2" object }
  { "result" object }
}
{ $description "Minimum of two numbers." }
{ $notes "This function can be applied to numbers or lists." } ;

HELP: om-max
{ $values
  { "obj1" object }
  { "obj2" object }
  { "result" object }
}
{ $description "Maximum of two numbers." }
{ $notes "This function can be applied to numbers or lists." } ;

HELP: list-min
{ $values
  { "obj" object }
  { "result" object }
}
{ $description "Returns the minimum element in a list." } ;

HELP: list-max
{ $values
  { "obj" object }
  { "result" object }
}
{ $description "Returns the maximum element in a list." } ;

HELP: tree-min
{ $values
  { "obj" object }
  { "&optionals" { $optionals } }
  { "result" number }
}
{ $optional-defaults
  { "min" { $link largest-float } }
}
{ $description "Returns the minimum element in a tree." } ;

HELP: tree-max
{ $values
  { "obj" object }
  { "&optionals" { $optionals } }
  { "result" number }
}
{ $optional-defaults
  { "max" { $link largest-float } " negated " }
}
{ $description "Returns the maximum element in a tree." } ;

HELP: om-mean
{ $values
  { "obj" object }
  { "&optionals" { $optionals } }
  { "result" float }
}
{ $optional-defaults
  { "weights" { $link f } }
}
{ $description "Arithmetic mean of numbers in a list." }
{ $notes "The optional input " { $snippet "weights" } " is a list of weights used to ponderate the successive elements in the list." } ;

HELP: om-random
{ $values
  { "low" null }
  { "high" null }
  { "result" null }
}
{ $description "Returns a random number between " { $snippet "low" } " and " { $snippet "high" } "." } ;

HELP: perturbation
{ $values
  { "percent" null }
  { "obj" object }
  { "result" null }
}
{ $description "Applies to " { $snippet "self" } " a random deviation bounded by the " { $snippet "percent" } " parameter, a value in [0 1]." }
{ $notes { $snippet "self" } " and " { $snippet "percent" } " can be numbers or lists." } ;

HELP: om-scale
{ $values
  { "minout" number }
  { "maxout" number }
  { "obj" object }
  { "&optionals" { $optionals } }
  { "result" object }
}
{ $optional-defaults
  { "minin" { $snippet "0" } }
  { "maxin" { $snippet "0" } }
}
{ $description "Scales " { $snippet "self" } " (a number or list of numbers) considered to be in the interval [" { $snippet "minin" } " " { $snippet "maxin" } "] towards the interval [" { $snippet "minout" } " " { $snippet "maxout" } "]." }
{ $notes "If [" { $snippet "minin" } " " { $snippet "maxin" } "] not specified or equal to [0 0], it is bound to the min and the max of the list." } ;

HELP: g-scaling/sum
{ $values
  { "obj1" object }
  { "obj2" object }
  { "result" object }
}
{ $description "Scales " { $snippet "list" } " (may be tree) so that its sum becomes " { $snippet "sum" } "." }
{ $notes "Trees must be well-formed.  The children of a node must be either all leaves or all nonleaves." } ;

HELP: om-scale/sum
{ $values
  { "obj" object }
  { "num" number }
  { "result" object }
}
{ $description "Scales " { $snippet "self" } " so that the sum of its elements become " { $snippet "sum" } "." } ;

HELP: factorize
{ $values
  { "obj" object }
  { "seq" sequence }
}
{ $description "Returns the prime decomposition of " { $snippet "number" } " in the form " { $snippet "{ { prime1 exponent1 } { prime2 exponent2 } ... }" } "." } ;

HELP: reduce-tree
{ $values
  { "fun" { $word/callable "( elt1 elt2 -- elt' )" } }
  { "&optionals" { $optionals } }
  { "quot" { $quotation "( obj -- result )" } }
  { "obj" object }
  { "result" object }
}
{ $optional-defaults
  { "accum" { $link f } }
}
{ $description "Applies the commutative binary " { $snippet "function" } " recursively throughout the list " { $snippet "self" } ".  (Applies to the first elements, then the result to the next one, and so forth until the list is exhausted.)"
  $nl
  "Function " { $snippet "+" } ", for instance, makes " { $snippet "reduce-tree" } " computing the sum of all elements in the list." }
{ $notes "Optional " { $snippet "accum" } " should be the neutral element for the " { $snippet "function" } " considered (i.e. initial result value).  If " { $snippet "accum" } " is " { $link f } ", figures out what the neutral can be (works for " { $link + } ", " { $link * } ", " { $link min } ", " { $link max } ")." } ;

HELP: interpolation
{ $values
  { "curve" number }
  { "num-samples" integer }
  { "begin" object }
  { "end" object }
  { "seq" sequence }
}
{ $description "Interpolates 2 numbers or lists (from " { $snippet "begin" } " to " { $snippet "end" } ") through " { $snippet "samples" } " steps."
  $nl
  { $snippet "curve" } " is an exponential factor interpolation (0 = linear)."} ;

HELP: rang-p
{ $values
  { "obj" object }
  { "&optionals" { $optionals } }
  { "quot" { $quotation "( seq -- seq' )" } }
  { "seq" sequence }
  { "seq'" sequence }
}
{ $optional-defaults
  { "test" { $link = } }
  { "key" { $link f } }
}
{ $description "Returns the position(s) of " { $snippet "elem" } " in " { $snippet "liste" } "."
  $nl
  { $snippet "test" } " is a function or function name used to test if the elements of the list are equal to " { $snippet "elem" } "."
  $nl
  { $snippet "key" } " is a function or function name that will be applied to elements before the test." } ;

HELP: list-explode
{ $values
  { "seq" sequence }
  { "|dst|" integer }
  { "dst" array }
}
{ $description "Segments " { $snippet "list" } " into " { $snippet "nlist" } " sublists of (if possible) equal length." }
{ $notes "If the number of divisions exceeds the number of elements in the list, the divisions will have one element each, and remaining divisions are repeat the last division value." } ;

HELP: list-filter
{ $values
  { "fun" { $word/callable "( elt -- ? )" } }
  { "mode" symbol }
  { "quot" { $quotation "( seq -- seq' )" } }
  { "seq" sequence }
  { "seq'" sequence }
}
{ $description "Filters out " { $snippet "list" } " using the predicate " { $snippet "test" } "."
  $nl
  { $snippet "test" } " may be a function name (a symbol) or it may be a visual function or patch in 'lambda' mode."
  $nl
  "If " { $snippet "list" } " is a list of lists, the filter is applied recursively in the sub-lists."
  $nl
  { $snippet "mode" } " " { $link 'reject } " means reject elements that verify " { $snippet "test" } "."
  $nl
  { $snippet "mode" } " " { $link 'pass } " means retain only elements that verify " { $snippet "test" } "." } ;

HELP: table-filter
{ $values
  { "numcol" integer }
  { "fun" { $word/callable "( elt -- ? )" } }
  { "mode" symbol }
  { "quot" { $quotation "( seq -- seq' )" } }
  { "seq" sequence }
  { "seq'" sequence }
}
{ $description "Filters out " { $snippet "list" } " (a list of lists) using the predicate " { $snippet "test" } "."
  $nl
  { $snippet "test" } " may be a function name (a symbol) or it may be a visual function or patch in 'lambda' mode."
  $nl
  "The predicate " { $snippet "test" } " is applied to the element of rank " { $snippet "numcol" } " in every sublist in " { $snippet "list" } " and filters the whole sublists."
  $nl
  { $snippet "numcol" } " counts from 0."
  $nl
  { $snippet "mode" } " " { $link 'reject } " means reject elements whose " { $snippet "numcol" } "th element verifies " { $snippet "test" } "."
  $nl
  { $snippet "mode" } " " { $link 'pass } " means retain only elements whose " { $snippet "numcol" } "th element verifies " { $snippet "test" } "." } ;

HELP: band-filter
{ $values
  { "bounds" sequence }
  { "mode" symbol }
  { "quot" { $quotation "( seq -- seq' )" } }
  { "seq" sequence }
  { "seq'" sequence }
}
{ $description "Filters out " { $snippet "list" } " using " { $snippet "bounds" } ". " { $snippet "bounds" } " is a pair or list of pairs " { $snippet "{ min-value max-value }" } "."
  $nl
  "If " { $snippet "list" } " is a list of lists, the filter is applied recursively in the sub-lists."
  $nl
  "If " { $snippet "bounds" } " is a list of pairs, each pair is applied to each successive element in " { $snippet "list" } "."
  $nl
  { $snippet "mode" } " " { $link 'reject } " means reject elements between the bounds."
  $nl
  { $snippet "mode" } " " { $link 'pass } " means retain only elements between the bounds." } ;

HELP: range-filter
{ $values
  { "ranges" sequence }
  { "mode" symbol }
  { "quot" { $quotation "( seq -- seq' )" } }
  { "seq" sequence }
  { "seq'" sequence }
}
{ $description "Select elements in " { $snippet "list" } " whose positions (couting from 0) in the list are defined by " { $snippet "posn" } "."
  $nl
  { $snippet "posn" } " is a list of pairs " { $snippet "{ min-pos max-pos }" } " in increasing order with no everlap."
  $nl
  { $snippet "mode" } " " { $link 'reject } " means reject the selected elements."
  $nl
  { $snippet "mode" } " " { $link 'pass } " means retain only the selected elements." } ;

HELP: posn-match
{ $values
  { "seq" sequence }
  { "positions" object }
  { "seq'" sequence }
}
{ $description "Constructs a new list by peeking elements in " { $snippet "list" } " at positions defined by " { $snippet "positions" } " (a list or tree of positions)." } ;

HELP: pgcd
{ $values
  { "a" null }
  { "b" null }
  { "result" null }
}
{ $description "Find the greats common divisor bethween 2 rational." } ;

ARTICLE: "om.kernel" "om.kernel"
{ $vocab-intro "om.kernel" "projects/01-basicproject/functions/kernel.lisp" } ;

ABOUT: "om.kernel"
