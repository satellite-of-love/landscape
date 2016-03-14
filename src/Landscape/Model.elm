module Landscape.Model (Model, MousePosition, init) where

import Set exposing (Set)
import Char exposing (KeyCode)


type alias MousePosition =
  ( Int, Int )


type alias Model =
  { pointer : MousePosition
  , messages : List String
  , keysDown : Set KeyCode
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
  , textInput =
      { isAThing = False
      , position = ( 0, 0 )
      , contents = ""
      }
  }