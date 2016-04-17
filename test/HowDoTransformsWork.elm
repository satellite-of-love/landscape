module HowDoTransformsWork (main) where

{-| Test page for checking my understanding of transforms

build with elm make --output foo.html test/HowDoTransformsWork.elm

and then open foo.html. Check that the top left corner of each box
is consistent with what the box says.

-}

import Html exposing (Html)
import Html.Attributes as Attr
import Landscape.Calculations as Calculations
import Mouse
import Window
import Signal exposing (Signal)


main : Signal Html
main =
  relativeMousePosition
    |> Signal.map view


view p =
  Html.div
    [ Attr.style [ ( "position", "absolute" ), ( "top", "0" ), ( "left", "0" ) ] ]
    [ showMousePos p
    , oneTransformCheck 35 50 1 0 0
    , oneTransformCheck 35 50 1 -10 -20
    , oneTransformCheck 35 50 2 -15 5
    , oneTransformCheck 35 50 0.5 15 25
    , oneTransformCheck 35 50 0.5 30 -40
    ]


showMousePos p =
  Html.text (toString p)


oneTransformCheck anchorX anchorY zoom x y =
  let
    cssTransformation =
      { fromLeft = anchorX, fromTop = anchorY, scale = zoom, translateX = x, translateY = y }

    expectedPlacement =
      Calculations.resultingPositionOnScreen cssTransformation
  in
    Html.div
      [ Attr.style
          ((Calculations.positioningStyles cssTransformation)
            ++ [ ( "border", "thin green solid" )
               , ( "transform-origin", "top left" )
               ]
          )
      ]
      [ Html.text
          ((toString expectedPlacement) ++ " because " ++ (toString cssTransformation))
      ]


type alias PositionOnScreen =
  ( Int, Int )


relativeMousePosition : Signal PositionOnScreen
relativeMousePosition =
  Signal.map3 relativize Mouse.position Window.width Window.height


relativize : ( Int, Int ) -> Int -> Int -> PositionOnScreen
relativize ( x, y ) w h =
  ( x * 100 // w, y * 100 // h )
