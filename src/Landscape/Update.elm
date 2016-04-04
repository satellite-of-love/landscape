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
  1


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
zoomOut state pointer =
  let
    newZoom =
      (max 1 (state.z - howMuchToZoomIn))

    newCenter =
      if newZoom == 1 then
        ( 35, 50 )
      else
        state.center
  in
    { state
      | z = newZoom
      , center = newCenter
    }


upArrowPressed : OutsideWorld -> Bool
upArrowPressed model =
  Set.member 38 model.keysDown


downArrowPressed : OutsideWorld -> Bool
downArrowPressed model =
  Set.member 40 model.keysDown
