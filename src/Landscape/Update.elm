module Landscape.Update where

import Landscape.Model exposing (Model)
import Landscape.Action exposing (Action(..))
import Set

update :  Action -> Model -> Model
update action model =
  case action of
    Click ->
      if upArrowPressed model then
        zoomIn model
      else
        model
    _ -> model

howMuchToZoomIn = 1

zoomIn : Model -> Model
zoomIn model =
  { model
  | z = model.z + howMuchToZoomIn
  , center = model.pointer
  }


upArrowPressed model =
  Set.member 38 model.keysDown