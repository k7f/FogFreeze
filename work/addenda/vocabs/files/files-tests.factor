! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.vocabs.files io.pathnames sequences tools.test ;
IN: addenda.vocabs.files.tests

[ { "keep-me.txt" } ] [
    "addenda.vocabs.files" ".txt" vocab-tests-dir* [ file-name ] map
] unit-test
