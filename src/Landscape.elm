module Landscape where

import Graphics.Element as E exposing (Element)
import Graphics.Collage as C exposing (Form)
import Text
import Html exposing (Html)

main : Html
main = C.collage 1000 748 forms |> Html.fromElement

forms : List Form
forms = 
  [
    C.toForm background,
    C.text someText
  ]

someText = Text.fromString "wat"


background = E.image 1000 748 "../images/solarsystem.png"
