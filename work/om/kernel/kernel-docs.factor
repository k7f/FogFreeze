! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: help.markup help.syntax kernel math math.order sequences words.symbol ;
IN: om.kernel

HELP: om+
{ $values
  { "obj1" object }
  { "obj2" object }
  { "result" null }
}
{ $description "Sum of two numbers or lists." } ;

HELP: om*
{ $values
  { "obj1" object }
  { "obj2" object }
  { "result" null }
}
{ $description "Product of two numbers or lists." } ;

HELP: om-
{ $values
  { "obj1" object }
  { "obj2" object }
  { "result" null }
}
{ $description "Difference of two numbers or lists." } ;

HELP: om/
{ $values
  { "obj1" object }
  { "obj2" object }
  { "result" null }
}
{ $description "Division of two  numbers or lists." } ;

HELP: om^
{ $values
  { "obj1" object }
  { "obj2" object }
  { "result" null }
}
{ $description "Exponentiation of base a and exponent b." } ;

HELP: om-e
{ $values
  { "obj" object }
  { "result" null }
}
{ $description "Exponential function." }
{ $notes "This function can be applied on numbers or lists." } ;

HELP: om-log
{ $values
  { "&optionals" null }
  { "obj" object }
  { "result" null }
}
{ $description "Logarithm function.  (The logarithm of a number to the base is the power to which the base must be raised in order to produce the number.)" }
{ $notes "The " { $snippet "base" } " argument is optional.  By default, " { $snippet "base" } " is equal to the number " { $emphasis "e" } ", so " { $snippet "om-log" } " computes the " { $emphasis "natural" } " logarithm of " { $snippet "n" } "."
$nl
"This function can be applied on numbers or lists." } ;

HELP: om-round
{ $values
  { "&optionals" null }
  { "obj" object }
  { "obj'" object }
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

HELP: om-mean
{ $values
  { "&optionals" null }
  { "obj" object }
  { "result" null }
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
  { "&optionals" object }
  { "minout" number }
  { "maxout" number }
  { "obj" object }
  { "result" object }
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
  { "&optionals" object }
  { "obj" object }
  { "fun" object }
  { "result" object }
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
  { "&optionals" object }
  { "seq" sequence }
  { "obj" object }
  { "seq'" sequence }
}
{ $description "Returns the position(s) of " { $snippet "elem" } " in " { $snippet "liste" } "."
$nl
{ $snippet "test" } " is a function or function name used to test if the elements of the list are equal to " { $snippet "elem" } "."
$nl
{ $snippet "key" } " is a function or function name that will be applied to elements before the test." } ;

HELP: list-filter
{ $values
  { "seq" sequence }
  { "fun" object }
  { "mode" symbol }
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

HELP: pgcd
{ $values
  { "a" null }
  { "b" null }
  { "result" null }
}
{ $description "Find the greats common divisor bethween 2 rational." } ;

ARTICLE: "om.kernel" "om.kernel"
"The " { $vocab-link "om.kernel" } " vocabulary is an experimental port of the file " { $snippet "projects/01-basicproject/functions/kernel.lisp" } " from the main " { $snippet "code" } " tree of OpenMusic."
$nl
"The text in descriptions and notes was copied verbatim from the original docstrings.  There may be little or no meaning left in it after the transfer." ;

ABOUT: "om.kernel"
