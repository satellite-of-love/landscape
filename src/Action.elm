module Action (Action(..), News(..), OutgoingNews(..)) where

import Char exposing (KeyCode)
import Set exposing (Set)
import Messages exposing (MessageImportance)
import Landscape exposing (InformativeText)
import Base exposing (PositionOnScreen)


type News action outgoingNews
  = DoThis action
  | ServerSays outgoingNews
  | MouseMove PositionOnScreen (Set KeyCode)
  | Click
  | NoOp


type Action
  = NewTextInput PositionOnScreen
  | ReceiveText String
  | DiscardText
  | SaveText
    -- landscape
  | ZoomIn PositionOnScreen
  | ZoomOut PositionOnScreen
    -- message pane
  | Disvisiblate MessageImportance
  | Envisiblate MessageImportance
  | PleasePrintTheModel
    -- news injector
  | ActivateNewsInjector
  | DiscardNewsInjector
  | NewsInjectorReceiveText String
  | InjectTheNews


type OutgoingNews
  = Save InformativeText
  | Focus String
