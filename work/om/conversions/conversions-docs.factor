! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.help.markup help.markup help.syntax math om.help.markup
       sequences strings ;
IN: om.conversions

HELP: approx-m
{ $values
  { "cents" { $class/sequence-of number } }
  { "approx" real }
  { "&optionals" { $optionals } }
  { "cents'" { $class/sequence-of number } }
}
{ $optional-defaults
  { "ref-midic" "0" }
}
{ $description "Returns an approximation of " { $snippet "midic" } " (in midicents) to the nearest tempered division of the octave."
  $nl
  { $list
    { { $snippet "approx = 1" } " whole tones" }
    { { $snippet "approx = 2" } " semi tones" }
    { { $snippet "approx = 4" } " quarter tones" }
    { { $snippet "approx = 8" } " eight tones" }
  }
  $nl
  "Floating values are allowed for " { $snippet "approx" } "."
  $nl
  { $snippet "ref-midic" } " is a midicent that is subtracted from " { $snippet "midic" } " before computation: the computation can then be carried on an interval rather than an absolute pitch." } ;

HELP: midicents>hz
{ $values
  { "cents" { $class/sequence-of number } }
  { "hz" { $class/sequence-of number } }
}
{ $description "Converts a (list of) midicent pitch(es) " { $snippet "midics" } " to frequencies (Hz)." } ;

HELP: hz>midicents
{ $values
  { "hz" { $class/sequence-of number } }
  { "&optionals" { $optionals } }
  { "cents" { $class/sequence-of number } }
}
{ $optional-defaults
  { "approx" "2" }
  { "ref-midic" "0" }
}
{ $description "Converts a frequency or list of frequencies to midicents."
  $nl
  "Approximation:"
  { $list
    { { $snippet "approx = 1" } " whole tones" }
    { { $snippet "approx = 2" } " semi tones" }
    { { $snippet "approx = 4" } " quarter tones" }
    { { $snippet "approx = 8" } " eight tones" }
  }
  $nl
  "Floating values are allowed for " { $snippet "approx" } "."
  $nl
  { $snippet "ref-midic" } " is a midicent that is subtracted from " { $snippet "midic" } " before computation: the computation can then be carried on an interval rather than an absolute pitch." } ;

HELP: +ascii-note-scales+
{ $var-description "The scales used by the functions " { $link midicents>string } " and " { $link string>midicents } "." } ;

HELP: midicents>string
{ $values
  { "cents" number }
  { "&optionals" { $optionals } }
  { "name" string }
}
{ $optional-defaults
  { "ascii-note-scale" "first element of " { $link +ascii-note-scales+ } }
}
{ $description "Converts " { $snippet "midic" } " to a string representing a symbolic ascii note." }
{ $see-also midicents>string* } ;

HELP: midicents>string*
{ $values
  { "cents" { $class/sequence-of number } }
  { "names" { $class/sequence-of string } }
}
{ $description "Converts " { $snippet "midics" } " to symbolic (ASCII) note names."
  $nl
  { $list
    "Symbolic note names follow standard notation with middle c (midicent 6000) being C3."
    "Semitones are labeled with a '#' or a 'b.'"
    "Quartertone flats are labeled with a '_', and quartertone sharps with a '+' (ex. C3 a quartertone sharp (midi-cent 6050), would be labeled 'C+3'."
    "Gradations smaller than a quartertone are expressed as the closest  quartertone + or - the remaining cent value (ex. midi-cent 8176 would be expressed as Bb4-24)."
  }
} ;

HELP: string>midicents
{ $values
  { "name" string }
  { "&optionals" { $optionals } }
  { "cents/f" { $maybe number } }
}
{ $optional-defaults
  { "ascii-note-scale" "first element of " { $link +ascii-note-scales+ } }
}
{ $description "Converts a string representing a symbolic ascii note to midicents." }
{ $see-also string>midicents* } ;

HELP: string>midicents*
{ $values
  { "names" { $class/sequence-of string } }
  { "cents" { $class/sequence-of number } }
}
{ $description "Converts " { $snippet "strs" } " to pitch values in midicents."
  $nl
  { $list
    "Symbolic note names follow standard notation with middle c (midicent 6000) being C3."
    "Semitones are labeled with a '#' or a 'b.'"
    "Quartertone flats are labeled with a '_', and quartertone sharps with a '+' (ex. C3 a quartertone sharp (midi-cent 6050), would be labeled 'C+3'."
    "Gradations smaller than a quartertone are expressed as the closest  quartertone + or - the remaining cent value (ex. midi-cent 8176 would be expressed as Bb4-24)."
  }
} ;

HELP: interval>string
{ $values
  { "cents" real }
  { "name" string }
}
{ $description "Converts a midicent interval to a symbolic interval." }
{ $see-also interval>string* } ;

HELP: interval>string*
{ $values
  { "cents" { $class/sequence-of real } }
  { "names" { $class/sequence-of string } }
}
{ $description { $link interval>string* } " takes an interval expressed in midi-cents, and returns a symbolic interval name."
  $nl
  "Intervals are labeled as follows:"
  $nl
  { $table
    { "1 = unison" "2m = minor second" }
    { "2M = major second" "3m = minor third" }
    { "3M = major third" "4 = perfect fourth" }
    { "4A = tritone" "5 = perfect fifth" }
    { "6m = minor sixth" "6M = major sixth" }
    { "7m = minor seventh" "7M = major seventh" }
  }
  $nl
  "All intervals larger than an octave are expressed by adding or subtracting an octave displacement after the simple interval name; for example, a major tenth becomes 3M+1, etc."
}
{ $notes "For the time being, the program has a strange way of expressing downward intervals: it labels the interval as its inversion, and then transposes downwards as necessary.  Thus, a major third down (-400 in midicents), returns 6m-1." } ;

HELP: string>interval
{ $values
  { "name" string }
  { "cents" real }
}
{ $description "Converts a symbolic interval to a midicent interval." }
{ $see-also string>interval* } ;

HELP: string>interval*
{ $values
  { "names" { $class/sequence-of string } }
  { "cents" { $class/sequence-of real } }
}
{ $description { $link string>interval* } " takes a symbolic interval name, and returns an interval expressed in midi-cents.  Intervals are labeled as follows:"
  $nl
  { $table
    { "1 = unison" "2m = minor second" }
    { "2M = major second" "3m = minor third" }
    { "3M = major third" "4 = perfect fourth" }
    { "4A = tritone" "5 = perfect fifth" }
    { "6m = minor sixth" "6M = major sixth" }
    { "7m = minor seventh" "7M = major seventh" }
  }
  $nl
  "All intervals larger than an octave are expressed by adding or subtracting an octave displacement after the simple interval name; for example, a major tenth becomes 3M+1, etc."
}
{ $notes "For the time being, Patchwork has a strange way of expressing downward intervals: it labels the interval as its inversion, and then transposes downwards as necessary.  Thus, a major third down 6m-1, returns -400 in midicents." } ;

HELP: beats>ms
{ $values
  { "nbeats" real }
  { "tempo" real }
  { "duration" float }
}
{ $description "Converts a symbolic rhythmic beat division into the corresponding duration in milliseconds." } ;

ARTICLE: "om.conversions" "om.conversions"
{ $vocab-intro "om.conversions" "projects/02-musicproject/functions/conversions.lisp" } ;

ABOUT: "om.conversions"
