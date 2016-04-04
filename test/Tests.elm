module Tests (..) where

import ElmTest exposing (..)
import String
import Landscape.Calculations as Subject


all : Test
all =
  suite
    "A Test Suite"
    [ test "Move to the left" movingOver
    , test "translate for the view" beSomewhere
    , test "move down from start" moveDown
    , test "see it be down" down10
    , test "move down farther" moveDownAgain
    , test "see it be down farther" down20
    , test "zoom in then out" zoomInAndThenOut
    , test "click in the center" clickingInTheCenterDoesNotChangeTheCenter
    , test "zoom in then out moving" zoomInAndThenOutMoving
    ]


movingOver =
  let
    currentCenter =
      ( 60, 50 )

    clicked =
      ( 28, 50 )

    expectedCenter =
      ( 53, 50 )

    ( _, actualCenter ) =
      Subject.findNewPlace 0 1 currentCenter clicked
  in
    assertEqual expectedCenter actualCenter


beSomewhere =
  let
    iWantTheCenterToBe =
      ( 3, 50 )

    thisShouldWork =
      "translate(32vw,0vh)"
  in
    assertEqual thisShouldWork (Subject.translateFunction 1 iWantTheCenterToBe)


moveDown =
  let
    currentCenter =
      ( 35, 50 )

    clicked =
      ( 35, 40 )

    ( _, actualCenter ) =
      Subject.findNewPlace 0 1 currentCenter clicked
  in
    assertEqual ( 35, 40 ) actualCenter


down10 =
  let
    center =
      ( 35, 40 )

    translation =
      "translate(0vw,10vh)"
  in
    assertEqual translation (Subject.translateFunction 1 center)


moveDownAgain =
  let
    currentCenter =
      ( 35, 40 )

    clicked =
      ( 35, 40 )

    expectedCenter =
      ( 35, 30 )

    ( _, actualCenter ) =
      Subject.findNewPlace 0 1 currentCenter clicked
  in
    assertEqual expectedCenter actualCenter


down20 =
  let
    center =
      ( 35, 30 )

    translation =
      "translate(0vw,20vh)"
  in
    assertEqual translation (Subject.translateFunction 1 center)



-- this would be a great property test


clickingInTheCenterDoesNotChangeTheCenter =
  let
    currentCenter =
      ( 35, 40 )

    clicked =
      ( 35, 50 )

    expectedCenter =
      ( 35, 40 )

    ( _, actualCenter ) =
      Subject.findNewPlace 0 1 currentCenter clicked
  in
    assertEqual expectedCenter actualCenter


zoomInAndThenOut =
  let
    currentCenter =
      ( 35, 50 )

    clicked =
      ( 10, 20 )

    thenClick =
      ( 35, 50 )

    zoomAmount =
      1

    startingZoom =
      1

    ( nextZ, newCenter ) =
      Subject.findNewPlace zoomAmount startingZoom currentCenter clicked

    ( finalZ, finalCenter ) =
      Subject.findNewPlace (-1 * zoomAmount) nextZ newCenter thenClick
  in
    assertEqual ( 1, ( 10, 20 ) ) ( finalZ, finalCenter )


zoomInAndThenOutMoving =
  let
    currentCenter =
      ( 35, 50 )

    clicked =
      ( 70, 60 )

    thenClick =
      ( 11, 10 )

    zoomAmount =
      1

    startingZoom =
      1

    ( nextZ, newCenter ) =
      Subject.findNewPlace zoomAmount startingZoom currentCenter clicked

    ( finalZ, finalCenter ) =
      Subject.findNewPlace (-1 * zoomAmount) nextZ newCenter thenClick
  in
    assertEqual ( 1, ( 58, 40 ) ) ( finalZ, finalCenter )
