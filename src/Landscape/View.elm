module Landscape.View (landscapePane) where

import Text
import Html exposing (Html)
import Html.Attributes as Attr
import Model exposing (Model, MousePosition, InformativeText)
import LandscapeCss exposing (beAt)
import Css exposing (vh, vw, asPairs)


landscapePane : Model -> Html
landscapePane model =
  Html.node
    "main"
    []
    ([ Html.canvas
        [ zoomTo model.z model.center ]
        []
     ]
      ++ List.map draw model.annotations
    )


zoomTo : Int -> MousePosition -> Html.Attribute
zoomTo zoomLevel ( x, y ) =
  let
    scaleFunction =
      "scale(" ++ (toString zoomLevel) ++ ")"
  in
    Attr.style
      [ ( "transform", scaleFunction )
      , ( "transform-origin", (toString x) ++ "vw " ++ (toString y) ++ "vh" )
      ]


draw : InformativeText -> Html
draw annotation =
  let
    ( x, y ) =
      annotation.position

    positioningCss =
      beAt (y |> toFloat |> vh) (x |> toFloat |> vw)
  in
    Html.label
      [ Attr.style
          (asPairs positioningCss)
        -- [ ( "position", "absolute" )
        -- , ( "top", (toString y) ++ "vh" )
        -- , ( "left", (toString x) ++ "vw" )
        -- ]
      ]
      [ Html.text annotation.text ]


pct i =
  (toString i) ++ "%"
