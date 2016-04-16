module HowDoTransformsWork (main) where

{-| Test page for checking my understanding of transforms

build with elm make --output foo.html test/HowDoTransformsWork.elm

and then open foo.html. Check that the top left corner of each box
is consistent with what the box says.

-}

import Html exposing (Html)
import Html.Attributes as Attr
import LandscapeCss exposing (absolutePositionAtCenter)
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
    [ showMousePos p, oneTransformCheck 1 0 0, oneTransformCheck 1 -10 -20 ]


showMousePos p =
  Html.text (toString p)


oneTransformCheck zoom x y =
  let
    cssTransformation =
      { scale = zoom, translateX = x, translateY = y }

    expectedPlacement =
      Calculations.resultingPositionOnScreen cssTransformation
  in
    Html.div
      [ Attr.style
          (absolutePositionAtCenter
            ++ [ ( "border", "thin green solid" )
               , ( "transform", Calculations.toStyle cssTransformation )
               ]
          )
      ]
      [ Html.text
          ((toString cssTransformation)
            ++ "I expect this to be at "
            ++ (toString expectedPlacement)
          )
      ]


type alias PositionOnScreen =
  ( Int, Int )


relativeMousePosition : Signal PositionOnScreen
relativeMousePosition =
  Signal.map3 relativize Mouse.position Window.width Window.height


relativize : ( Int, Int ) -> Int -> Int -> PositionOnScreen
relativize ( x, y ) w h =
  ( x * 100 // w, y * 100 // h )
