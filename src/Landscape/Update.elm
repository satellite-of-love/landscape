module Landscape.Update (..) where

import Model exposing (Model, MousePosition)
import Action exposing (Action(ZoomIn, ZoomOut), News(Click))
import Set


update : Action -> Model -> Model
update action model =
  case action of
    ZoomIn pointer ->
      if upArrowPressed model then
        zoomIn model pointer
      else if downArrowPressed model then
        zoomOut model pointer
      else
        model

    _ ->
      model


seeTheWorld : News Action -> Model -> List Action
seeTheWorld news model =
  case news of
    Click ->
      if upArrowPressed model then
        [ ZoomIn model.pointer ]
      else if downArrowPressed model then
        [ ZoomOut model.pointer ]
      else
        []

    _ ->
      []


howMuchToZoomIn =
  1


zoomIn : Model -> MousePosition -> Model
zoomIn model pointer =
  { model
    | z = model.z + howMuchToZoomIn
    , center = pointer
  }


zoomOut : Model -> MousePosition -> Model
zoomOut model pointer =
  { model
    | z = (max 1 (model.z - howMuchToZoomIn))
  }


upArrowPressed : Model -> Bool
upArrowPressed model =
  Set.member 38 model.keysDown


downArrowPressed : Model -> Bool
downArrowPressed model =
  Set.member 40 model.keysDown
