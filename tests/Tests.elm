module Tests where

import ElmTest exposing (..)

import String
import Landscape.Update as Subject


all : Test
all =
    suite "A Test Suite"
        [
            movingOver
        ]

movingOver =
  let
    currentCenter = (60, 50)
    clicked = (28, 50)
    expectedCenter = (3, 50)
    (_, actualCenter) = Subject.findNewPlace 0 1 currentCenter clicked
  in
    assertEqual expectedCenter actualCenter