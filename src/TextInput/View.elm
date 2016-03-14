module TextInput.View (possibleInput) where

import Html exposing (Html)
import Html.Attributes as Attr
import Landscape.Model exposing (Model, MousePosition)


possibleInput : Model -> List Html
possibleInput model =
  if model.textInput.isAThing then
    [ input model.textInput ]
  else
    []


input textInputModel =
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
