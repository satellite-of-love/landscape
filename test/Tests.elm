module Tests where

import ElmTest exposing (..)

import String
import Landscape.Calculations as Subject


all : Test
all =
    suite "A Test Suite"
        [
            test "Move to the left" movingOver
          , test "translate for the view" beSomewhere
          , test "move down from start" moveDown
          , test "see it be down" down10
          , test "move down farther" moveDownAgain
          , test "see it be down farther" down20
        ]

movingOver =
  let
    currentCenter = (60, 50)
    clicked = (28, 50)
    expectedCenter = (53, 50)
    (_, actualCenter) = Subject.findNewPlace 0 1 currentCenter clicked
  in
    assertEqual expectedCenter actualCenter

beSomewhere =
  let
    iWantTheCenterToBe = (3, 50)
    thisShouldWork = "translate(32vw,0vh)"
  in
    assertEqual thisShouldWork (Subject.translateFunction 1 iWantTheCenterToBe)

moveDown =
  let
   currentCenter = (35, 50)
   clicked = (35, 40)
   (_, actualCenter) = Subject.findNewPlace 0 1 currentCenter clicked
  in
    assertEqual (35, 40) actualCenter

down10 =
  let
   center = (35, 40)
   translation = "translate(0vw,10vh)"
  in
    assertEqual translation (Subject.translateFunction 1 center)


moveDownAgain =
  let
   currentCenter = (35, 40)
   clicked = (35, 40)
   expectedCenter = (35, 30)
   (_, actualCenter) = Subject.findNewPlace 0 1 currentCenter clicked
  in
    assertEqual expectedCenter actualCenter

down20 =
  let
   center = (35, 30)
   translation = "translate(0vw,20vh)"
  in
    assertEqual translation (Subject.translateFunction 1 center)


