module LandscapeCss (css) where

import Css exposing (overflow, scroll, border3, verticalAlign, height, width, groove, top, left, vw, vh, stylesheet, px, rgb, backgroundColor, margin, padding, position, absolute)
import Css.Elements exposing (aside)


css =
  stylesheet
    [ aside
        [ backgroundColor white
        , margin (px 0)
        , padding (px 0)
        , position absolute
        , top (vh 0)
        , left (vw 70)
        , height (vh 100)
        , width (vw 30)
        , border3 mediumBorder groove green
        , verticalAlign top
        , overflow scroll
        ]
    ]


white =
  rgb 255 255 255


green =
  rgb 10 205 10


mediumBorder =
  (px 3)



--aside {
--  background-color: white;
--  margin: 0;
--  padding: 0;
--  left: 70%;
--  width: 30%;
--  height: 100%;
--  border: medium groove green;
--  position: absolute;
--  vertical-align: top;
--  overflow: scroll;
--}
