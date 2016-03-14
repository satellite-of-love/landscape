module Landscape.View (landscapePane) where

import Graphics.Element as E exposing (Element)
import Graphics.Collage as C exposing (Form)
import Text
import Html exposing (Html)
import Html.Attributes as Attr
import Landscape.Model exposing (Model, MousePosition)


landscapePane height model =
  Html.div
    [ Attr.style
        [ ( "position", "absolute" )
        ]
    ]
    [ landscape height model.pointer ]


landscape : Int -> MousePosition -> Html
landscape height model =
  C.collage 1000 height (forms height model) |> Html.fromElement


forms : Int -> MousePosition -> List Form
forms height model =
  [ C.toForm (background height)
  , C.text (Text.fromString (toString model))
  ]


background height =
  E.image 1000 height "images/solarsystem.png"
