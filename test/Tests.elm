module Tests (..) where

import ElmTest exposing (..)
import String
import Landscape.Calculations as Subject
import ZoomAndCreateText


all : Test
all =
  suite
    "A Test Suite"
    ([ test "Move to the left" movingOver
     , test "translate for the view" beSomewhere
     , test "move down from start" moveDown
     , test "see it be down" down10
     , test "move down farther" moveDownAgain
     , test "see it be down farther" down20
     , test "zoom in then out" zoomInAndThenOut
     , test "click in the center" clickingInTheCenterDoesNotChangeTheCenter
     , test "zoom in then out moving" zoomInAndThenOutMoving
     ]
      ++ ZoomAndCreateText.tests
    )


movingOver =
  let
    clicked =
      ( 28, 50 )

    expectedPos =
      { x = 53, y = 50, zoom = 1 }

    finalPos =
      Subject.findNewPlace 0 { zoom = 1, x = 60, y = 50 } clicked
  in
    assertEqual expectedPos finalPos


beSomewhere =
  let
    iWantThePosToBe =
      { x = 3
      , y = 50
      , zoom = 1
      }

    thisShouldWork =
      "translate(32vw,0vh)"
  in
    assertEqual thisShouldWork (Subject.translateFunction iWantThePosToBe)


moveDown =
  let
    currentPos =
      { x = 35
      , y = 50
      , zoom = 1
      }

    clicked =
      ( 35, 40 )

    finalPos =
      Subject.findNewPlace 0 currentPos clicked
  in
    assertEqual { zoom = 1, x = 35, y = 40 } finalPos


down10 =
  let
    currentPos =
      { x = 35
      , y = 40
      , zoom = 1
      }

    translation =
      "translate(0vw,10vh)"
  in
    assertEqual translation (Subject.translateFunction currentPos)


moveDownAgain =
  let
    currentPos =
      { x = 35
      , y = 40
      , zoom = 1
      }

    clicked =
      ( 35, 40 )

    finalPos =
      Subject.findNewPlace 0 currentPos clicked
  in
    assertEqual { zoom = 1, x = 35, y = 30 } finalPos


down20 =
  let
    currentPos =
      { x = 35
      , y = 30
      , zoom = 1
      }

    translation =
      "translate(0vw,20vh)"
  in
    assertEqual translation (Subject.translateFunction currentPos)



-- this would be a great property test


clickingInTheCenterDoesNotChangeTheCenter =
  let
    currentPos =
      { x = 35
      , y = 50
      , zoom = 1
      }

    clicked =
      ( 35, 50 )

    finalPos =
      Subject.findNewPlace 0 currentPos clicked
  in
    assertEqual { zoom = 1, x = 35, y = 50 } finalPos


zoomInAndThenOut =
  let
    currentPos =
      { x = 35
      , y = 50
      , zoom = 1
      }

    clicked =
      ( 10, 20 )

    thenClick =
      ( 35, 50 )

    zoomAmount =
      1

    nextPos =
      Subject.findNewPlace zoomAmount currentPos clicked

    finalPos =
      Subject.findNewPlace (-1 * zoomAmount) nextPos thenClick
  in
    assertEqual { zoom = 1, x = 10, y = 20 } finalPos


zoomInAndThenOutMoving =
  let
    currentPos =
      { x = 35
      , y = 50
      , zoom = 1
      }

    clicked =
      ( 70, 60 )

    thenClick =
      ( 11, 10 )

    zoomAmount =
      1

    nextPos =
      Subject.findNewPlace zoomAmount currentPos clicked

    finalPos =
      Subject.findNewPlace (-1 * zoomAmount) nextPos thenClick
  in
    assertEqual { zoom = 1, x = 58, y = 40 } finalPos
