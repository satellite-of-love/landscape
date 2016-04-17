module CreateTextProperties (..) where

import Check exposing (Claim, true, for)
import Check.Producer as Producer
import ZoomAndCreateText exposing (resultingAnnotation, bothWithinTolerance)


claims : List Claim
claims =
  [ Check.claim
      "On save, text stays where you put it"
      `true` (\click -> resultingAnnotation click |> existsAnd (bothWithinTolerance click))
      `for` Producer.tuple ( (Producer.rangeInt 0 70), (Producer.rangeInt 0 99) )
  ]


existsAnd : (a -> Bool) -> Maybe a -> Bool
existsAnd f m =
  case m of
    Nothing ->
      False

    Just something ->
      f something
