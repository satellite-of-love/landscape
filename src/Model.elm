module Model (..) where

import Set exposing (Set)
import Char exposing (KeyCode)
import String
import Messages exposing (Message, MessageVisibility, allVisible)
import Landscape exposing (InformativeText)


type alias MousePosition =
  ( Int, Int )


type alias OutsideWorld =
  { pointer : MousePosition
  , keysDown : Set KeyCode
  , previousKeysDown : Set KeyCode
  }


type alias ApplicationState =
  { messages : List Message
  , messageVisibility : MessageVisibility
  , textInput :
      { isAThing : Bool
      , position : MousePosition
      , contents : String
      }
  , annotations : List InformativeText
  , z : Int
  , center : MousePosition
  }


type alias Model =
  { world : OutsideWorld
  , state : ApplicationState
  }


updateState : (a -> ApplicationState -> ApplicationState) -> a -> Model -> Model
updateState update action model =
  { model
    | state = update action model.state
  }


init : Model
init =
  { world =
      { pointer = ( 0, 0 )
      , keysDown = Set.empty
      , previousKeysDown = Set.empty
      }
  , state =
      { messages = []
      , messageVisibility = allVisible
      , textInput =
          { isAThing = False
          , position = ( 0, 0 )
          , contents = ""
          }
      , annotations = []
      , z = 1
      , center = ( 0, 0 )
      }
  }


keysPressed : OutsideWorld -> Set KeyCode
keysPressed model =
  Set.diff model.keysDown model.previousKeysDown


printableKeysDown : OutsideWorld -> String
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
