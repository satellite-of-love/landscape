module Landscape.Model (Model, MousePosition, init, keysPressed) where

import Set exposing (Set)
import Char exposing (KeyCode)


type alias MousePosition =
  ( Int, Int )


type alias Model =
  { pointer : MousePosition
  , messages : List String
  , keysDown : Set KeyCode
  , previousKeysDown : Set KeyCode
  , textInput :
      { isAThing : Bool
      , position : MousePosition
      , contents : String
      }
  }


init : Model
init =
  { pointer = ( 0, 0 )
  , messages = []
  , keysDown = Set.empty
  , previousKeysDown = Set.empty
  , textInput =
      { isAThing = False
      , position = ( 0, 0 )
      , contents = ""
      }
  }


keysPressed : Model -> Set KeyCode
keysPressed model =
  Set.diff model.keysDown model.previousKeysDown
