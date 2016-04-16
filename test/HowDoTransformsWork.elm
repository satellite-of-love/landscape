module HowDoTransformsWork (main) where

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
    [ showMousePos p, oneTransformCheck ]


showMousePos p =
  Html.text (toString p)


oneTransformCheck =
  let
    cssTransformation =
      { scale = 1, translateX = 0, translateY = 0 }
  in
    Html.div
      [ Attr.style
          (absolutePositionAtCenter
            ++ [ ( "border", "thin green solid" )
               , ( "transform", Calculations.toStyle cssTransformation )
               ]
          )
      ]
      [ Html.text (toString cssTransformation) ]


type alias PositionOnScreen =
  ( Int, Int )


relativeMousePosition : Signal PositionOnScreen
relativeMousePosition =
  Signal.map3 relativize Mouse.position Window.width Window.height


relativize : ( Int, Int ) -> Int -> Int -> PositionOnScreen
relativize ( x, y ) w h =
  ( x * 100 // w, y * 100 // h )
