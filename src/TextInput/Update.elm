module TextInput.Update (inputReact) where

import Landscape.Model exposing (Model)
import Landscape.Action exposing (Action(..))
import Char exposing (KeyCode)
import Set exposing (Set)


inputReact action model =
  case action of
    Click ->
      { model
        | textInput =
            { isAThing = Set.member 'T' (Set.map Char.fromCode model.keysDown)
            , contents = ""
            , position = model.pointer
            }
      }

    _ ->
      model
