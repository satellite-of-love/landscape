module Model (..) where

import Set exposing (Set)
import Char exposing (KeyCode)
import String
import Messages exposing (Message, MessageVisibility, allVisible)
import Landscape exposing (InformativeText)
import NewsInjector exposing (NewsInjectorPane)


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
  , newsInjector : NewsInjectorPane
  }


type alias Clock =
  Int


type alias Model =
  { world : OutsideWorld
  , state : ApplicationState
  , clock : Clock
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
      , center = ( 35, 50 )
      , newsInjector =
          NewsInjector.init
      }
  , clock = 1
  }


keysPressed : OutsideWorld -> Set KeyCode
keysPressed world =
  Set.diff world.keysDown world.previousKeysDown


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
