module LandscapeCss (css, CssClass(..)) where

import Css exposing ((.), boxSizing, whiteSpace, noWrap, minWidth, border2, fontFamily, monospace, sansSerif, inset, em, borderBox, overflow, hidden, top, vw, scroll, border3, verticalAlign, height, width, groove, vh, stylesheet, px, rgb, backgroundColor, margin, padding, position, absolute)
import Css.Elements exposing (output, canvas, aside, ul, mainElement)


type CssClass
  = WhereAmI


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
             , padding (px 2)
             , height fullHeight
             , width messagesWidth
             , border3 mediumBorder groove green
             , verticalAlign top
             , overflow scroll
             , boxSizing borderBox
             ]
        )
    , canvas
        (beAt veryTop veryLeft
          ++ landscapeSize
          ++ [ backgroundImageUrl "images/solarsystem.png"
             , Css.property "background-size" "100% 100%"
             , Css.property "transition" "1s ease-in-out"
             ]
        )
    , mainElement
        (beAt veryTop veryLeft
          ++ landscapeSize
          ++ [ overflow hidden ]
        )
    , output
        [ fontFamily monospace
        , whiteSpace noWrap
        ]
    , ((.) WhereAmI)
        [ padding (em 0.1)
        , border2 (px 3) inset
        , margin (em 0.2)
        , minWidth (vw 10)
        ]
    ]


landscapeSize =
  [ width landscapeWidth
  , height fullHeight
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


grey =
  rgb 100 100 100


green =
  rgb 10 205 10


mediumBorder =
  (px 3)