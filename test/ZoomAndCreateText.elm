module ZoomAndCreateText (..) where

import ElmTest exposing (..)
import Update as Subject
import Model
import Landscape.Calculations as Calculations
import Action exposing (News(..), Action(ReceiveText))
import Set
import Char


z =
  makeATest 30 33


makeATest x y =
  case (resultingAnnotation ( x, y )) of
    Nothing ->
      ElmTest.fail "did not find text output"

    Just ( xPos, yPos ) ->
      assert (bothWithinTolerance ( x, y ) ( xPos, yPos ))


resultingAnnotation ( x, y ) =
  let
    news =
      triggerSomeZoom
        ++ (triggerInformativeTextCreation ( x, y ) "Hello")

    resultingModel =
      List.foldl (dropSecond Subject.updateModel) Model.init news
  in
    List.head (resultingModel.state.annotations)
      |> Maybe.map (accountForZoom resultingModel.state)


bothWithinTolerance ( x1, y1 ) ( x2, y2 ) =
  (withinTolerance x1 x2) && (withinTolerance y1 y2)


withinTolerance a b =
  -1 <= (a - b) && (a - b) <= 1



-- pretty sure this could be done with fn composition


dropSecond f a b =
  fst (f a b)


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


accountForZoom state informativeText =
  let
    transforms =
      Calculations.calculateTransformation state.whereAmI informativeText.position
  in
    Calculations.resultingPositionOnScreen transforms
