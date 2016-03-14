module TextInput.Update (inputReact) where

import Landscape.Model exposing (Model)
import Landscape.Action exposing (Action(..))
import Char exposing (KeyCode)
import Set exposing (Set)


inputReact action model =
  case action of
    MouseMove spot keys ->
      { model
        | pointer = spot
        , keysDown = keys
      }

    _ ->
      model
