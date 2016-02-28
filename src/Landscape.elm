module Landscape (..) where

import Graphics.Element as E exposing (Element)
import Graphics.Collage as C exposing (Form)
import Text
import Html exposing (Html)
import Html.Attributes as Attr
import Signal exposing (Signal)
import Mouse


type alias MousePosition = ( Int, Int )
type alias Model =
  { 
    pointer: MousePosition
  } 

lANDSCAPE_H = 768

type Action = 
    MouseMove MousePosition


main : Signal Html
main =
  mousePointer
  |> Signal.map produceModel
  |> Signal.map view

mousePointer : Signal Action
mousePointer =   
  Mouse.position 
  |> Signal.map MouseMove

-- update section
produceModel : Action -> Model
produceModel action =
  case action of
    MouseMove spot -> 
      { 
        pointer = spot
      }

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
landscape model =
  C.collage 1000 lANDSCAPE_H (forms model) |> Html.fromElement


forms : Model -> List Form
forms model  =
  [ C.toForm background
  , C.text (Text.fromString (toString model.pointer))
  ]


background =
  E.image 1000 lANDSCAPE_H "images/solarsystem.png"
