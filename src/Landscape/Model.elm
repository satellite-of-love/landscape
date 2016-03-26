module Landscape.Model (Model, MousePosition, InformativeText, init, keysPressed) where

import Set exposing (Set)
import Char exposing (KeyCode)


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
  , messages : List String
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


keysPressed : Model -> Set KeyCode
keysPressed model =
  Set.diff model.keysDown model.previousKeysDown
