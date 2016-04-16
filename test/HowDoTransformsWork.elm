module HowDoTransformsWork (main) where

import Html exposing (Html)
import Html.Attributes as Attr
import LandscapeCss exposing (absolutePositionAtCenter)
import Landscape.Calculations as Calculations
import Html.CssHelpers as Help


main : Html
main =
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
