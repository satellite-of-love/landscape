module Model (..) where

import Set exposing (Set)
import Char exposing (KeyCode)
import String
import Messages exposing (Message, MessageVisibility, allVisible)
import Clock exposing (Clock)
import Landscape exposing (InformativeText)
import NewsInjector exposing (NewsInjectorPane)
import Main


type alias MousePosition =
  ( Int, Int )


type alias OutsideWorld =
  { pointer : MousePosition
  , keysDown : Set KeyCode
  , previousKeysDown : Set KeyCode
  }


type alias InformativeTextId =
  String


type alias ApplicationState =
  { messages : List Message
  , messageVisibility : MessageVisibility
  , textInput :
      { isAThing : Bool
      , position : MousePosition
      , contents : String
      , id : InformativeTextId
      }
  , annotations : List InformativeText
  , z : Int
  , center : MousePosition
  , newsInjector : NewsInjectorPane
  }


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
          -- this whole thing should be a Maybe
          { isAThing = False
          , position = ( 0, 0 )
          , contents = ""
          , id = ""
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
