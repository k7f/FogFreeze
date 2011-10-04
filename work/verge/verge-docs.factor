! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: classes help.markup help.syntax kernel math quotations sequences ;
IN: verge

HELP: set-trace
{ $values
  { "level/?" "a " { $link fixnum } " or a " { $link boolean } }
}
{ $description "Turn tracing of verges on or off.  Optionally, specify tracing level." } ;

HELP: get-trace
{ $values
  { "level/?" "a " { $link fixnum } " or a " { $link boolean } }
}
{ $description "Get current level, or a flag, which controls tracing of verges." } ;

HELP: should-trace?
{ $values
  { "min-level" fixnum }
  { "?" boolean }
}
{ $description "Return false if tracing level is less than " { $snippet "min-level" } " or tracing is controlled by a flag.  Otherwise, return true." } ;

HELP: <verge-state>
{ $values
  { "start" "a nonempty " { $link sequence } }
  { "slip" quotation }
  { "strains" sequence }
  { "state" "a " { $link verge-state } }
}
{ $description "Constructor of the " { $link verge-state } " class." }
{ $notes "Whenever it is important to guarantee, that the list of strains remains constant during a single verge, call " { $link clone } " before passing the strains (individual strains would still be allowed to change their state, however, as a result of side-effects)." } ;

HELP: (verge)
{ $values
  { "state" "a " { $link verge-state } }
  { "goal" quotation }
  { "step" quotation }
  { "hitlist" sequence }
  { "?" boolean }
}
{ $description "The result sequence is never empty, and it always contains a prefix equal to the value passed as " { $snippet "start" } " to " { $link <verge-state> } ".  If the result boolean is true, then the result sequence fulfills the goal." } ;

HELP: verge
{ $values
  { "start" "a nonempty " { $link sequence } }
  { "first-slip-maker" quotation }
  { "next-slip-maker" quotation }
  { "strains" sequence }
  { "goal" quotation }
  { "step" quotation }
  { "hitlist" sequence }
  { "?" boolean }
}
{ $description "The result sequence is never empty, and it always contains " { $snippet "start" } " as a prefix.  If the result boolean is true, then the result sequence fulfills the goal." } ;

ARTICLE: "transitions-and-goal" "transitions and goal"
"Step and slip transitions, as well as the goal, are specified by quotations."
$nl
"Step quotation takes a predecessor sequence and returns two values: the last element of a successor sequence, and a slip quotation.  There is always exactly one step quotation used for a single verge.  The returned slip quotation may be empty (i.e. equal " { $link f } ").  If it is not empty, then it computes the consecutive slip transition."
$nl
"Slip quotation takes nothing and returns two values: the last element of a successor sequence, and another slip quotation or " { $link f } "."
$nl
"The goal quotation, unique for a single verge, is a predicate that takes a sequence and returns a boolean value."
$nl
"The actual stack effects of step and goal quotations are extended, redundantly, for the sake of efficiency.  They contain the last element of an input sequence as an additional argument and retain the entire input sequence as an additional result." ;

ARTICLE: "main-loop" "main loop"
"The implementation of a single verge starts from the initial node of a verge space, then enters the loop, which may be presented schematically, using fictitious words, as"
{ $code "[ <goal-reached?> ] [ <do-step> <maybe-slip> ] until" }
"The " { $snippet "<do-step>" } " part executes the currently valid step transition, i.e. the one directed from the current node.  It does so repeatedly, followed by the " { $snippet "<maybe-slip>" } " part (and unless an exception is thrown), until " { $snippet "<goal-reached?>" } " reports that the current node is final."
$nl
"The skeleton of " { $snippet "<maybe-slip>" } " is"
{ $code "[ <strains-failed?> ] [ <fallback> ] while" }
"This is the inner loop guarded by the " { $snippet "<strains-failed?>" } " part, which performs feasibility checks."
$nl
"The " { $snippet "<fallback>" } " is yet another loop:"
{ $code "[ [ <do-slip> ] [ <do-backtrack> ] unless* ] loop" }
"where " { $snippet "<do-slip>" } " executes the currently valid slip transition, and " { $snippet "<do-backtrack>" } " executes the currently valid backtracking transition."
$nl
"If there is no valid slip transition, the return value of " { $snippet "<do-slip>" } " is " { $link f } ".  " { $snippet "<do-backtrack>" } " however, returns " { $link f } " whenever it actually backtracks \u{em-dash} otherwise it throws an error.  Therefore, every backtracking transition is directly or indirectly (i.e. after further backtracking) followed by a slip transition, unless the whole main loop longjumps due to a backtracking error \u{em-dash} which indicates exhaustion of the feasible subset of the space."
$nl
"Note, that slip and backtracking transitions, as well as the step, are always unique or nonexistent, because all " { $link "verge-space" } "s are non-branching.";

ARTICLE: "invariants" "invariants"
{ $list
  { "FIXME (untrue at the top) The current node's LPP is always feasible, because the implementation guarantees that infeasible node's step transition is never executed.  This property simplifies the implementation of certain " { $link "strains" } "." }
} ;

ARTICLE: "backtracking" "backtracking"
"Backtracking is implemented in a lightweight (hopefully...) way, by using two dedicated stacks, instead of full-blown continuations." ;

ARTICLE: "implementation" "implementation"
{ $subsections
  "transitions-and-goal"
  "main-loop"
  "invariants"
  "backtracking"
} ;

ARTICLE: "sequence-space" "sequence space"
{ $emphasis "Sequence space" } ", in verge speak, is an implicit digraph, where the nodes are sequences, and the arcs are transitions.  It contains exactly one " { $emphasis "initial node" } ", a set of intermediate nodes, and a set (possibly empty) of " { $emphasis "final nodes" } " \u{em-dash} aka the " { $emphasis "goal" } "."
$nl
"There are four types of transitions in a sequence space."
$nl
{ $list
  { { $emphasis "Step transition" } " connects a sequence to one of its shortest proper suffixes (SPS)." }
  { { $emphasis "Backtracking transition" } " is the inverted arc of a step transition of the same space: it connects a sequence to its longest proper prefix (LPP)." }
  { { $emphasis "Slip transition" } " connects two different sequences of equal LPP." }
  { { $emphasis "Jump transition" } " is any transition other than backtracking, step or slip." }
}
$nl
"A sequence space is " { $emphasis "non-branching" } ", if for any node and any transition type, a transition from that node and of that type does not exist or is unique." ;

ARTICLE: "verge-space" "verge space"
{ $emphasis "Verge space" } " is a non-branching sequence space without jump transitions and containing all backtracking transitions.  Furthermore it is required, that every node of a verge space must be reachable from its initial node, which is necessarily a non-empty sequence.  The graph induced by the set of backtracking transitions of such a space is always a tree."
$nl
"The nodes of a verge space are partitioned into " { $emphasis "feasible" } " and " { $emphasis "unfeasible" } " subsets.  The partition is controlled by a set of " { $emphasis "strains" } " (cf the "
{ $link "strains" } " vocabulary), and it should fulfill two conditions:"
{ $list
  { "the feasible subset is finite;" }
  { "no infeasible sequence may ever be a prefix of a feasible one." }
} ;

ARTICLE: "verging" "verging"
"\u00201c" { $emphasis "Verging" } "\u00201d is simply short for \u00201csearching in a verge space\u00201d.  A single " { $emphasis "verge" } " is such a process of verging, which starts from the initial sequence, and stops whenever any of the two conditions is met:"
$nl
{ $list
  { "current node satisfies the goal predicate;" }
  { "current node is unfeasible, and there is no more backtracking credit left." }
}
$nl
"If searching ends due to the first condition, then the verge is " { $emphasis "successful" } ", even if the node is unfeasible.  Otherwise \u{em-dash} the verge " { $emphasis "fails" } "." 
$nl
"(Note that in the current implementation goal predicate is never evaluated for unfeasible sequences.  Thus, the two conditions are effectively disjoint.)" ;

ARTICLE: "foundations" "foundations"
{ $subsections
  "sequence-space"
  "verge-space"
  "verging"
} ;

ARTICLE: "verge" "verge"
"The " { $vocab-link "verge" } " vocabulary deals with searching in verge spaces."
$nl
{ $subsections
  "foundations"
  "implementation"
} ;

ABOUT: "verge"
