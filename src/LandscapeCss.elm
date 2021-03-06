module LandscapeCss (css, CssClass(..), beAt, absolutePositionAtCenter) where

import Css exposing (..)
import Css.Elements exposing (canvas, ul)


type CssClass
  = WhereAmI
  | Chunder
  | Notice
  | Save
  | CurrentlyVisible
  | CurrentlyInvisible
  | NewsInjectorPane
  | Angry


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
    [ selector
        "aside"
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
          ++ [ backgroundImageUrl "images/elmscape.png"
             , Css.property "background-size" "100% 100%"
             , Css.property "transition" "1s ease-in-out"
             ]
        )
    , selector
        "main"
        (beAt veryTop veryLeft
          ++ landscapeSize
          ++ [ overflow hidden ]
        )
    , selector
        "output"
        [ fontFamily monospace
        , whiteSpace noWrap
        ]
    , ((.) NewsInjectorPane)
        (beAt (vh 10) (vw 10)
          ++ [ width (vw 50)
             , height (vh 80)
             , Css.property "transition" "0.5s ease-in-out"
             , border2 (px 4) groove
             , backgroundColor gray
             , padding (px 10)
             ]
        )
    , selector
        "textarea"
        [ width (pct 100)
        , height (pct 90)
        ]
    , ((.) Angry)
        [ color red ]
    , ((.) WhereAmI)
        [ padding (em 0.1)
        , border2 (px 3) inset
        , margin (em 0.2)
        , minWidth (vw 10)
        ]
    , ((.) Notice)
        [ backgroundColor pink
        ]
    , ((.) Save)
        [ backgroundColor blue
        , fontWeight bold
        ]
    , ((.) CurrentlyVisible)
        [ (border2 (px 3) inset)
        ]
    , ((.) CurrentlyInvisible)
        [ (border2 (px 3) outset)
        ]
    ]


landscapeSize =
  [ width landscapeWidth
  , height fullHeight
  ]


absolutePositionAtCenter =
  asPairs (beAt (vh 50) (vw 35))


beAt myTop myLeft =
  [ position absolute
  , Css.top myTop
  , Css.left myLeft
  ]


backgroundImageUrl url =
  Css.property "background-image" ("url(" ++ url ++ ")")


white =
  rgb 255 255 255


pink =
  rgb 65 200 169


blue =
  rgb 253 145 152


red =
  rgb 355 0 0


gray =
  rgb 200 200 200


green =
  rgb 10 205 10


mediumBorder =
  (px 3)
