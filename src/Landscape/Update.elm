module Landscape.Update (..) where

import Landscape.Model exposing (Model)
import Landscape.Action exposing (Action(..))
import Set


update : Action -> Model -> Model
update action model =
  case action of
    Click ->
      if upArrowPressed model then
        zoomIn model
      else if downArrowPressed model then
        zoomOut model
      else
        model

    _ ->
      model


howMuchToZoomIn =
  1


zoomIn : Model -> Model
zoomIn model =
  { model
    | z = model.z + howMuchToZoomIn
    , center = model.pointer
  }


zoomOut : Model -> Model
zoomOut model =
  { model
    | z = (max 1 (model.z - howMuchToZoomIn))
  }


upArrowPressed model =
  Set.member 38 model.keysDown


downArrowPressed model =
  Set.member 40 model.keysDown
