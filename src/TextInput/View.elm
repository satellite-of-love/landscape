module TextInput.View (possibleInput) where

import Html exposing (Html)
import Html.Attributes as Attr
import Signal exposing (Address)
import Html.Events exposing (on, targetValue)
import Landscape.Model exposing (Model, MousePosition)
import Landscape.Action exposing (Action(..))


possibleInput : Address Action -> Model -> List Html
possibleInput address model =
  if model.textInput.isAThing then
    [ input address model.textInput ]
  else
    []


input address textInputModel =
  let
    ( x, y ) =
      textInputModel.position
  in
    Html.input
      [ Attr.style
          [ ( "position", "relative" )
          , ( "top", (toString y) ++ "vh" )
          , ( "left", (toString x) ++ "vw" )
          ]
      , Attr.value textInputModel.contents
      , Attr.attribute "autofocus" "true"
      , on "input" targetValue (Signal.message address << TypedSomething)
      ]
      []


pct : Int -> String
pct i =
  (toString i) ++ "vh"
