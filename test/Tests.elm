module Tests where

import ElmTest exposing (..)

import String
import Landscape.Update as Subject


all : Test
all =
    suite "A Test Suite"
        [
            test "Move to the left" movingOver
          , test "should fail" (assert False)
        ]

movingOver =
  let
    currentCenter = (60, 50)
    clicked = (28, 50)
    expectedCenter = (3, 50)
    (_, actualCenter) = Subject.findNewPlace 0 1 currentCenter clicked
  in
    assertEqual expectedCenter actualCenter