! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: help.markup help.syntax vocabs.files ;
IN: addenda.vocabs.files

HELP: vocab-tests-dir*
{ $values
  { "vocab" "a vocabulary specifier" }
  { "extension" "a filename extension" }
  { "paths" "a sequence of pathname strings" }
}
{ $description "Outputs a sequence of pathnames for the files within the " { $snippet "tests" } " subdirectory of the " { $snippet "vocab" } "'s source directory.  The output is constrained to those filenames which end with the given extension." }
{ $see-also vocab-tests-dir } ;

ARTICLE: "addenda.vocabs.files" "addenda.vocabs.files"
{ $vocab-link "addenda.vocabs.files" } ;

ABOUT: "addenda.vocabs.files"
