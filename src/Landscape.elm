module Landscape (..) where

import Graphics.Element as E exposing (Element)
import Graphics.Collage as C exposing (Form)
import Text
import Html exposing (Html)
import Html.Attributes as Attr
import Signal exposing (Signal)
import Mouse


type alias Model =
  ( Int, Int )

lANDSCAPE_H = 768

main : Signal Html
main =
  Mouse.position 
  |> Signal.map view


view : Model -> Html
view pointer =
  Html.div []
    [
      Html.div [ Attr.style [ ("display", "inline-block"), ("*display", "inline"), ("border", "medium dashed blue") ] ] [ landscape pointer ]
    , messages
    ]

messages : Html
messages = 
  Html.div 
  [
    Attr.style 
    [
      ("width", "200px")
    , ("height", (toString lANDSCAPE_H) ++ "px")
    , ("border", "medium dashed green")
    , ("display", "inline-block")
    , ("*display", "inline")
    , ("vertical-align", "top")
    ]
  ]
  [
    Html.li [] [ Html.text "yo" ]
  ]

landscape : Model -> Html
landscape pointer =
  C.collage 1000 lANDSCAPE_H (forms pointer) |> Html.fromElement


forms : Model -> List Form
forms pointer =
  [ C.toForm background
  , C.text (Text.fromString (toString pointer))
  ]


background =
  E.image 1000 lANDSCAPE_H "images/solarsystem.png"
