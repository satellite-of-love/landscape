module Landscape.Update (..) where

import Model exposing (OutsideWorld, ApplicationState, MousePosition)
import Action exposing (Action(ZoomIn, ZoomOut), News(Click), OutgoingNews)
import Set
import Landscape.Calculations exposing (findNewPlace)


update : Action -> ApplicationState -> ApplicationState
update action model =
  case action of
    ZoomIn pointer ->
      zoomIn model pointer

    ZoomOut pointer ->
      zoomOut model pointer

    _ ->
      model


seeTheWorld : News a b -> OutsideWorld -> List Action
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
  0


zoomIn : ApplicationState -> MousePosition -> ApplicationState
zoomIn state click =
  let
    ( newZ, newCenter ) =
      findNewPlace howMuchToZoomIn state.z state.center click
  in
    { state
      | z = newZ
      , center = newCenter
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
