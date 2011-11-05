! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: classes help.markup help.syntax kernel math quotations sequences ;
IN: ff.tracing

HELP: TRACING:
{ $syntax "TRACING: flag" }
{ $values { "flag" boolean } }
{ $description "Enables or disables compilation of tracing blocks." } ;

HELP: <TRACING
{ $syntax "<TRACING ... TRACING>" }
{ $description "Marks the beginning of a tracing block." }
{ $notes "If tracing code is written within tracing blocks, it will generate no overhead after deployment." } ;

HELP: TRACING>
{ $syntax "<TRACING ... TRACING>" }
{ $description "Marks the end of a tracing block." }
{ $notes "If tracing code is written within tracing blocks, it will generate no overhead after deployment." } ;

{ POSTPONE: TRACING: POSTPONE: <TRACING POSTPONE: TRACING> } related-words

HELP: set-tracing-off
{ $description "Turn tracing off." } ;

HELP: set-tracing-level
{ $values
  { "level" fixnum }
}
{ $description "Turn regular tracing on.  Specify tracing level." }
{ $errors "Throws an error if input is not a " { $link fixnum } "." } ;

HELP: set-tracing-hack
{ $values
  { "hack" { "any " { $link object } " other than " { $link fixnum } " or " { $link f } } }
}
{ $description "Turn specialized tracing on." }
{ $errors "Throws an error when given " { $link fixnum } " or " { $link f } "." }
{ $notes "Specialized traces are to be introduced when there is a need for exploration of a particular problem.  A tracing hack should target a single feature and be removed as soon as the problem is solved." } ;

HELP: should-trace?
{ $values
  { "min-level/hack" object }
  { "?" boolean }
}
{ $description "Return true when given a " { $link fixnum } ", regular tracing is on and tracing level is greater or equal to " { $snippet "min-level" } ", or, when given not a " { $link fixnum } " and specialized tracing is set to a " { $snippet "hack" } ".  Otherwise, return false." }
{ $notes "Specialized traces are to be introduced when there is a need for exploration of a particular problem.  A tracing hack should target a single feature and be removed as soon as the problem is solved." } ;

HELP: tracing?
{ $values
  { "?" boolean }
}
{ $description "Return true if regular tracing is on and tracing level is set to 1 or more." } ;

HELP: high-tracing?
{ $values
  { "?" boolean }
}
{ $description "Return true if regular tracing is on and tracing level is set to 2 or more." } ;

HELP: full-tracing?
{ $values
  { "?" boolean }
}
{ $description "Return true if regular tracing is on and tracing level is set to 3 or more." } ;

ARTICLE: "tracing" "Tracing framework"
"The " { $vocab-link "ff.tracing" } " vocabulary is a simple framework for ad hoc, synchronous, development-time tracing -- as opposed to full-blown, systematic, asynchronous, after-deployment " { $vocab-link "logging" } "."
{ $see-also "logging" } ;

ABOUT: "tracing"
