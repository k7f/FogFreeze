! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: help.markup help.syntax kernel math om.help.markup ;
IN: om.graphics

HELP: om-point
{ $var-description "" } ;

HELP: <om-point>
{ $values
  { "x" number }
  { "y" number }
  { "pt" om-point }
}
{ $description "" } ;

HELP: om-add-points
{ $values
  { "pt1" om-point }
  { "pt2" om-point }
  { "newpt" om-point }
}
{ $description "" } ;

HELP: om-subtract-points
{ $values
  { "pt1" om-point }
  { "pt2" om-point }
  { "newpt" om-point }
}
{ $description "" } ;

HELP: om-point-*
{ $values
  { "pt" om-point }
  { "coef" number }
  { "newpt" om-point }
}
{ $description "" } ;

HELP: dot-prod-2D
{ $values
  { "pt1" om-point }
  { "pt2" om-point }
  { "result" number }
}
{ $description "" } ;

HELP: norm-2D
{ $values
  { "pt" om-point }
  { "result" number }
}
{ $description "" } ;

HELP: dist2D
{ $values
  { "pt1" om-point }
  { "pt2" om-point }
  { "result" number }
}
{ $description "" } ;

HELP: dist-to-line
{ $values
  { "pt" om-point }
  { "lpt1" om-point }
  { "lpt2" om-point }
  { "result" number }
}
{ $description "" } ;

HELP: om-point-in-line?
{ $values
  { "pt" om-point }
  { "lpt1" om-point }
  { "lpt2" om-point }
  { "delta" number }
  { "?" boolean }
}
{ $description "" } ;

HELP: om-rect
{ $var-description "" } ;

HELP: <om-rect>
{ $values
  { "left" number }
  { "top" number }
  { "right" number }
  { "bottom" number }
  { "rect" om-rect }
}
{ $description "" } ;

HELP: om-pts-to-rect
{ $values
  { "pt1" om-point }
  { "pt2" om-point }
  { "rect" om-rect }
}
{ $description "" } ;

HELP: om-rect-top
{ $values
  { "rect" om-rect }
  { "num" number }
}
{ $description "" } ;

HELP: om-rect-bottom
{ $values
  { "rect" om-rect }
  { "num" number }
}
{ $description "" } ;

HELP: om-rect-left
{ $values
  { "rect" om-rect }
  { "num" number }
}
{ $description "" } ;

HELP: om-rect-right
{ $values
  { "rect" om-rect }
  { "num" number }
}
{ $description "" } ;

HELP: om-rect-w
{ $values
  { "rect" om-rect }
  { "num" number }
}
{ $description "" } ;

HELP: om-rect-h
{ $values
  { "rect" om-rect }
  { "num" number }
}
{ $description "" } ;

HELP: om-rect-topleft
{ $values
  { "rect" om-rect }
  { "num" number }
}
{ $description "" } ;

HELP: om-rect-bottomright
{ $values
  { "rect" om-rect }
  { "num" number }
}
{ $description "" } ;

HELP: om-sect-rect
{ $values
  { "rect1" om-rect }
  { "rect2" om-rect }
  { "newrect/f" "an " { $link om-rect } " or " { $link POSTPONE: f } }
}
{ $description "" } ;

HELP: om-point-in-rect?
{ $values
  { "pt" om-point }
  { "rect" om-rect }
  { "?" boolean }
}
{ $description "" } ;

ARTICLE: "om.graphics" "om.graphics"
{ $vocab-intro "om.graphics" "api/om-LW/graphics.lisp" } ;

ABOUT: "om.graphics"
