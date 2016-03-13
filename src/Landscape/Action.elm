module Landscape.Action (Action) where

import Char exposing (KeyCode)
import Set exposing (Set)
import Landscape.Model exposing (MousePosition)


type Action
  = MouseMove MousePosition (Set KeyCode)
  | Click
