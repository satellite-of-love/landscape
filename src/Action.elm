module Action (Action(..), News(..), OutgoingNews(..)) where

import Char exposing (KeyCode)
import Set exposing (Set)
import Model exposing (MousePosition)
import Messages exposing (MessageImportance)
import Landscape exposing (InformativeText)


type News action outgoingNews
  = DoThis action
  | Ack outgoingNews
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
  | ActivateNewsInjector
  | DiscardNewsInjector
  | NewsInjectorReceiveText String
  | InjectTheNews


type OutgoingNews
  = Save InformativeText
