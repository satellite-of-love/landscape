module Landscape.View (landscapePane) where

import Text
import Html exposing (Html)
import Html.Attributes as Attr
import Landscape.Model exposing (Model, MousePosition, InformativeText)


landscapePane : Int -> Model -> Html
landscapePane height model =
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
  in
    Html.label
      [ Attr.style
          [ ( "position", "absolute" )
          , ( "top", (toString y) ++ "vh" )
          , ( "left", (toString x) ++ "vw" )
          ]
      ]
      [ Html.text annotation.text ]


pct i =
  (toString i) ++ "%"
