! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: assocs classes help.markup help.syntax kernel sequences ;
IN: addenda.classes.tuple

HELP: not-a-subclass
{ $values
  { "base-obj" object }
  { "obj" object }
  { "base-class" class }
  { "class" class }
}
{ $description "" } ;

HELP: clone-as
{ $values
  { "obj" object }
  { "exemplar" object }
  { "newobj" object }
}
{ $description "If " { $snippet "exemplar" } "'s class is derived from " { $snippet "obj" } "'s, outputs a newly-allocated tuple with the same values of base slots as " { $snippet "obj" } ", but of the same type and with the same values of remaining slots as " { $snippet "exemplar" } "." }
{ $errors { $link not-a-subclass } " is thrown, if the class of " { $snippet "exemplar" } " is not a subclass of the class of " { $snippet "obj" } "." }
{ $notes "This is similar to " { $link clone-like } ", which, however, preserves only the type of " { $snippet "exemplar" } ", but ignores its length.  Overloading " { $link clone-like } " would lead to confusion anyway, because it is declared in " { $vocab-link "sequences" } "." }
{ $see-also clone-as* } ;

HELP: clone-as*
{ $values
  { "obj" object }
  { "newslots" null }
  { "newclass" class }
  { "newobj" object }
}
{ $description "If " { $snippet "newclass" } " is derived from " { $snippet "obj" } "'s class, outputs a newly-allocated tuple with the same values of base slots as " { $snippet "obj" } ", but of the " { $snippet "newclass" } " type and with the values of remaining slots copied from " { $snippet "newslots" } "." }
{ $errors { $link not-a-subclass } " is thrown, if the " { $snippet "newclass" } " is not a subclass of the class of " { $snippet "obj" } "." }
{ $see-also clone-as } ;

HELP: tuple>assoc
{ $values
  { "tuple" tuple }
  { "assoc" assoc }
}
{ $description "" } ;

HELP: supply-defaults
{ $values
  { "tuple" tuple }
  { "defaults" assoc }
  { "tuple'" tuple }
}
{ $description "" } ;

ARTICLE: "addenda.classes.tuple" "addenda.classes.tuple"
{ $vocab-link "addenda.classes.tuple" } ;

ABOUT: "addenda.classes.tuple"
