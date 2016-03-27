module Landscape.Model (Model, MousePosition, InformativeText, init, keysPressed, betterFromCode, xyz, printableKeysDown) where

import Set exposing (Set)
import Char exposing (KeyCode)
import String
import Messages exposing (Message(..))


type alias MousePosition =
  ( Int, Int )


type alias InformativeText =
  { text : String
  , position : MousePosition
  }


type alias Model =
  { pointer : MousePosition
  , z : Int
  , center : MousePosition
  , messages : List Message
  , keysDown : Set KeyCode
  , previousKeysDown : Set KeyCode
  , textInput :
      { isAThing : Bool
      , position : MousePosition
      , contents : String
      }
  , annotations : List InformativeText
  }


init : Model
init =
  { pointer = ( 0, 0 )
  , z = 1
  , center = ( 0, 0 )
  , messages = []
  , keysDown = Set.empty
  , previousKeysDown = Set.empty
  , textInput =
      { isAThing = False
      , position = ( 0, 0 )
      , contents = ""
      }
  , annotations = []
  }


xyz : Model -> ( Int, Int, Int )
xyz model =
  let
    ( x, y ) =
      model.pointer
  in
    ( x, y, model.z )


keysPressed : Model -> Set KeyCode
keysPressed model =
  Set.diff model.keysDown model.previousKeysDown


printableKeysDown : Model -> String
printableKeysDown model =
  String.join "," (Set.toList (Set.map betterFromCode model.keysDown))


betterFromCode : KeyCode -> String
betterFromCode keyCode =
  case keyCode of
    38 ->
      "up"

    40 ->
      "down"

    13 ->
      "enter"

    other ->
      if isOrdinaryChar other then
        Char.fromCode other |> String.fromChar
      else
        (toString other)


isOrdinaryChar keyCode =
  (65 <= keyCode) && (keyCode <= 90)
