module Landscape (..) where

import Graphics.Element as E exposing (Element)
import Graphics.Collage as C exposing (Form)
import Text
import Html exposing (Html)
import Signal exposing (Signal)
import Mouse


type alias Model =
  ( Int, Int )


main : Signal Html
main =
  Mouse.position 
  |> Signal.map view


view : Model -> Html
view pointer =
  Html.div []
    [
      landscape pointer
    , messages
    ]

messages : Html
messages = Html.text "yo"

landscape : Model -> Html
landscape pointer =
  C.collage 1000 748 (forms pointer) |> Html.fromElement


forms : Model -> List Form
forms pointer =
  [ C.toForm background
  , C.text (Text.fromString (toString pointer))
  ]


background =
  E.image 1000 748 "images/solarsystem.png"
