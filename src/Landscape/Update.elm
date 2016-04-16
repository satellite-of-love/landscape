module Landscape.Update (..) where

import Model exposing (OutsideWorld, ApplicationState, PositionOnScreen)
import Action exposing (Action(ZoomIn, ZoomOut), News(Click), OutgoingNews)
import Set
import Landscape.Calculations as Calculations
import Landscape


respondToActions : Action -> ApplicationState -> ApplicationState
respondToActions action model =
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


zoomIn : ApplicationState -> PositionOnScreen -> ApplicationState
zoomIn state click =
  { state
    | whereAmI = Calculations.findNewPlace howMuchToZoomIn state.whereAmI click
  }


zoomOut : ApplicationState -> PositionOnScreen -> ApplicationState
zoomOut state pointer =
  let
    oldPos =
      state.whereAmI

    newZoom =
      (max 1 (oldPos.zoom - howMuchToZoomIn))

    newPos =
      if newZoom == 1 then
        Landscape.initialPosition
      else
        { oldPos | zoom = newZoom }
  in
    { state
      | whereAmI = newPos
    }


upArrowPressed : OutsideWorld -> Bool
upArrowPressed model =
  Set.member 38 model.keysDown


downArrowPressed : OutsideWorld -> Bool
downArrowPressed model =
  Set.member 40 model.keysDown
