module Action (Action(..), News(..), OutgoingNews(..)) where

import Char exposing (KeyCode)
import Set exposing (Set)
import Messages exposing (MessageImportance)
import Landscape exposing (InformativeText)


type alias Position =
  ( Int, Int )


type News action outgoingNews
  = DoThis action
  | ServerSays outgoingNews
  | MouseMove Position (Set KeyCode)
  | Click
  | NoOp


type Action
  = NewTextInput Position
  | ReceiveText String
  | DiscardText
  | SaveText
  | ZoomIn Position
  | ZoomOut Position
  | Disvisiblate MessageImportance
  | Envisiblate MessageImportance
  | ActivateNewsInjector
  | DiscardNewsInjector
  | NewsInjectorReceiveText String
  | InjectTheNews


type OutgoingNews
  = Save InformativeText
  | Focus String
