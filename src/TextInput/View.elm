module TextInput.View (view) where

import String
import Html exposing (Html)
import Html.Attributes as Attr
import Signal exposing (Address)
import Html.Events exposing (on, targetValue)
import Model exposing (ApplicationState)
import Action exposing (Action(ReceiveText))


view : Address Action -> ApplicationState -> List Html
view address model =
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
          , ( "width", (toString (8 * (String.length textInputModel.contents))) ++ "px" )
          ]
      , Attr.id textInputModel.id
      , Attr.value textInputModel.contents
      , on "input" targetValue (Signal.message address << ReceiveText)
      ]
      []


pct : Int -> String
pct i =
  (toString i) ++ "vh"
