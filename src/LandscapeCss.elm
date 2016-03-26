module LandscapeCss (css) where

import Css exposing (overflow, top, vw, scroll, border3, verticalAlign, height, width, groove, vh, stylesheet, px, rgb, backgroundColor, margin, padding, position, absolute)
import Css.Elements exposing (canvas, aside, ul)


fullHeight =
  (vh 100)


landscapeWidth =
  (vw 70)


messagesWidth =
  (vw 30)


veryTop =
  (px 0)


veryLeft =
  (px 0)


css =
  stylesheet
    [ aside
        (beAt veryTop landscapeWidth
          ++ [ backgroundColor white
             , margin (px 0)
             , padding (px 0)
             , height fullHeight
             , width messagesWidth
             , border3 mediumBorder groove green
             , verticalAlign top
             , overflow scroll
             ]
        )
    , canvas
        (beAt veryTop veryLeft
          ++ [ backgroundImageUrl "images/solarsystem.png"
             , Css.property "background-size" "100% 100%"
             , width landscapeWidth
             , height fullHeight
             ]
        )
    ]


beAt myTop myLeft =
  [ position absolute
  , Css.top myTop
  , Css.left myLeft
  ]


backgroundImageUrl url =
  Css.property "background-image" ("url(" ++ url ++ ")")


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
