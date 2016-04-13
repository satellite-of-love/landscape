module Main (..) where

import Signal exposing (Signal)
import ElmTest exposing (consoleRunner)
import Console exposing (IO, run)
import Graphics.Element exposing (Element)
import Task
import Tests


console : IO ()
console =
  consoleRunner Tests.all


port runner : Signal (Task.Task x ())
port runner =
  run console


main : Element
main =
  ElmTest.elementRunner Tests.all
