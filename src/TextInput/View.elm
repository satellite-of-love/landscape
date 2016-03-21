module TextInput.View (possibleInput) where

import Html exposing (Html)
import Html.Attributes as Attr
import Signal exposing (Address)
import Landscape.Model exposing (Model, MousePosition)
import Landscape.Action exposing (Action)


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
          [ ( "position", "absolute" )
          , ( "top", px y )
          , ( "left", px x )
          ]
      , Attr.value textInputModel.contents
      ]
      []


px : Int -> String
px i =
  (toString i) ++ "px"
