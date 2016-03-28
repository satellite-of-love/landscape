module Landscape.Update (..) where

import Model exposing (OutsideWorld, ApplicationState, MousePosition)
import Action exposing (Action(ZoomIn, ZoomOut), News(Click))
import Set


update : Action -> ApplicationState -> ApplicationState
update action model =
  case action of
    ZoomIn pointer ->
      zoomIn model pointer

    ZoomOut pointer ->
      zoomOut model pointer

    _ ->
      model


seeTheWorld : News Action -> OutsideWorld -> List Action
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


zoomIn : ApplicationState -> MousePosition -> ApplicationState
zoomIn model pointer =
  { model
    | z = model.z + howMuchToZoomIn
    , center = pointer
  }


zoomOut : ApplicationState -> MousePosition -> ApplicationState
zoomOut model pointer =
  { model
    | z = (max 1 (model.z - howMuchToZoomIn))
  }


upArrowPressed : OutsideWorld -> Bool
upArrowPressed model =
  Set.member 38 model.keysDown


downArrowPressed : OutsideWorld -> Bool
downArrowPressed model =
  Set.member 40 model.keysDown
