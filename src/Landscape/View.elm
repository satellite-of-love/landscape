module Landscape.View (landscapePane) where

import Text
import Html exposing (Html)
import Html.Attributes as Attr
import Landscape.Model exposing (Model, MousePosition)


landscapePane : Int -> Model -> Html
landscapePane height model =
  Html.div []
  [
    Html.canvas [][],
    mousePointerText model
  ]


mousePointerText : Model -> Html
mousePointerText model =
  Html.div
   [ Attr.style
      [ ( "position", "absolute" ),
        ( "background", "images/solarsystem.png"),
        ( "top", "500px"),
        ( "left", "396px")
      ]
    ]
    [ Html.output [] [Html.text (toString model.pointer)]]

