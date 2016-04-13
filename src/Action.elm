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
    -- landscape
  | ZoomIn Position
  | ZoomOut Position
    -- message pane
  | Disvisiblate MessageImportance
  | Envisiblate MessageImportance
    -- news injector
  | ActivateNewsInjector
  | DiscardNewsInjector
  | NewsInjectorReceiveText String
  | InjectTheNews


type OutgoingNews
  = Save InformativeText
  | Focus String
