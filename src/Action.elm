module Action (Action(..), News(..), OutgoingNews(..)) where

import Char exposing (KeyCode)
import Set exposing (Set)
import Model exposing (MousePosition)
import Messages exposing (MessageImportance)
import Landscape exposing (InformativeText)


type News action
  = DoThis action
  | MouseMove MousePosition (Set KeyCode)
  | Click
  | NoOp


type Action
  = NewTextInput MousePosition
  | ReceiveText String
  | DiscardText
  | SaveText
  | ZoomIn MousePosition
  | ZoomOut MousePosition
  | Disvisiblate MessageImportance
  | Envisiblate MessageImportance
  | Chunder String


type OutgoingNews
  = Save InformativeText
