module Model (..) where

import Set exposing (Set)
import Char exposing (KeyCode)
import String
import Messages exposing (Message, MessageVisibility, allVisible)
import Clock exposing (Clock)
import Landscape exposing (InformativeText, ZoomLevel, PositionInDrawing, WhereAmI)
import NewsInjector exposing (NewsInjectorPane)
import Base


type alias PositionOnScreen =
  Base.PositionOnScreen


type alias OutsideWorld =
  { pointer : PositionOnScreen
  , keysDown : Set KeyCode
  , previousKeysDown : Set KeyCode
  }


type alias InformativeTextId =
  String


type alias ApplicationState =
  { -- messages
    messages : List Message
  , messageVisibility :
      MessageVisibility
      -- textInput
  , textInput :
      { isAThing : Bool
      , position : PositionOnScreen
      , contents : String
      , id : InformativeTextId
      }
      -- Landscape
  , annotations : List InformativeText
  , whereAmI :
      WhereAmI
      -- news injector
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
      , whereAmI = Landscape.initialPosition
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
