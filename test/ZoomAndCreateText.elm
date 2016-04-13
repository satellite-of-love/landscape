module ZoomAndCreateText (..) where

import ElmTest exposing (..)
import Update as Subject
import Model
import Landscape.Calculations as Calculations
import Action exposing (News(..), Action(ReceiveText))
import Set
import Char


z =
  let
    -- could be anywhere in the landscape
    whereIClicked =
      ( 30, 33 )

    news =
      triggerSomeZoom
        ++ (triggerInformativeTextCreation whereIClicked "Hello")

    resultingModel =
      List.foldl (dropSecond Subject.updateModel) Model.init news

    resultingAnnotation =
      List.head (resultingModel.state.annotations)
        |> Maybe.map (accountForZoom resultingModel.state)
  in
    case resultingAnnotation of
      Nothing ->
        ElmTest.fail "did not find text output"

      Just position ->
        assertEqual whereIClicked position



-- pretty sure this could be done with fn composition


dropSecond f a b =
  fst (f a b)


triggerInformativeTextCreation pos text =
  let
    holdingT =
      Set.fromList [ Char.toCode 'T' ]

    enter : Char.KeyCode
    enter =
      13

    holdingEnter =
      Set.fromList [ enter ]
  in
    [ MouseMove pos holdingT
    , Click
    , DoThis (ReceiveText text)
    , MouseMove ( 0, 0 ) holdingEnter
    ]


triggerSomeZoom =
  let
    up : Char.KeyCode
    up =
      38

    holdingUp =
      Set.fromList [ up ]
  in
    [ MouseMove ( 15, 20 ) holdingUp
    , Click
    ]


accountForZoom state informativeText =
  let
    transforms =
      Calculations.calculateTransformation state.z state.center informativeText.position
  in
    Calculations.resultingPositionOnScreen transforms
