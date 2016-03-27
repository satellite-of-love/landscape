module Landscape.Action (Action(..)) where

import Char exposing (KeyCode)
import Set exposing (Set)
import Landscape.Model exposing (MousePosition)
import Messages exposing (MessageImportance)


type Action
  = MouseMove MousePosition (Set KeyCode)
  | Click
  | TypedSomething String
  | SaveText
  | Disvisiblate MessageImportance
  | Envisiblate MessageImportance
  | NoOp
