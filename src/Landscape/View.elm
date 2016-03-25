module Landscape.View (landscapePane) where

import Text
import Html exposing (Html)
import Html.Attributes as Attr
import Landscape.Model exposing (Model, MousePosition, InformativeText)


landscapePane : Int -> Model -> Html
landscapePane height model =
  Html.div []
  ([
    Html.canvas [][],
    mousePointerText model
  ] ++ List.map draw model.annotations)

draw: InformativeText -> Html
draw annotation =
  let
    (x, y) = annotation.position
  in
  Html.div [
    Attr.style
    [ ( "position", "absolute")
      , ("top", px y)
      , ("left", px x)
    ]
  ] [ Html.text annotation.text ]

px i =
  (toString i) ++ "px"

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

