! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: arrays help.markup help.syntax om.support words ;
IN: om.syntax

HELP: '(
{ $description "Starts a literal " { $link array } ", which has to be terminated with closing parenthesis: " { $snippet ")" } ".  This is similar to " { $link POSTPONE: { } ", but " { $link word } "s inside parens are converted to " { $link cl-symbol } "s."
$nl
{ $snippet "()" } "-arrays may be nested.  However, internal opening parentheses should be left unescaped: those with leading " { $snippet "'" } "s will be converted to " { $link cl-symbol } "s ." }
{ $notes "Not converted are two parsing words: " { $link POSTPONE: " } " and " { $link POSTPONE: CHAR: } "." }
{ $see-also "lisp-alikes" } ;

ARTICLE: "om.syntax" "om.syntax"
"The " { $vocab-link "om.syntax" } " vocabulary contains parsing words intended to imitate Common Lisp constructs or expected to be otherwise specific to the \"om\" tree of vocabularies."
{ $see-also "lisp-alikes" } ;

ABOUT: "om.syntax"
