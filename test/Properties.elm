module Main (..) where

import ElmTest
import Check exposing (Evidence, Claim, that, is, for)
import Check.Test
import Check.Producer as Producer
import List
import Signal exposing (Signal)
import Console exposing (IO, run)
import Task


console : IO ()
console =
  ElmTest.consoleRunner (Check.Test.evidenceToTest evidence)


port runner : Signal (Task.Task x ())
port runner =
  run console


myClaims : Claim
myClaims =
  Check.suite
    "List Reverse"
    [ Check.claim
        "Reversing a list twice yields the original list"
        `that` (\list -> List.reverse (List.reverse list))
        `is` identity
        `for` Producer.list Producer.int
    , Check.claim
        "Reversing a list does not modify its length"
        `that` (\list -> List.length (List.reverse list))
        `is` (\list -> List.length list)
        `for` Producer.list Producer.int
    ]


evidence : Evidence
evidence =
  Check.quickCheck myClaims
