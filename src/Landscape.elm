module Landscape where

import Graphics.Element as E exposing (Element)
import Graphics.Collage as C exposing (Form)
import Text

main : Element
main = C.collage 1000 748 forms

forms : List Form
forms = 
  [
    C.toForm background,
    C.text someText
  ]

someText = Text.fromString "wat"


background = E.image 1000 748 "../images/solarsystem.png"
