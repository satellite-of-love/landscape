module Main (..) where

import ElmTest
import Check exposing (Evidence, Claim, that, is, for)
import Check.Test
import Check.Producer as Producer
import Signal exposing (Signal)
import Console exposing (IO)
import Task
import CreateTextProperties


console : IO ()
console =
  ElmTest.consoleRunner (Check.Test.evidenceToTest evidence)


port runner : Signal (Task.Task x ())
port runner =
  Console.run console


myClaims : Claim
myClaims =
  Check.suite
    "Useful thing"
    CreateTextProperties.claims


evidence : Evidence
evidence =
  Check.quickCheck myClaims
