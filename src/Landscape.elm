module Landscape where

import Graphics.Element as E exposing (Element)
import Graphics.Collage as C exposing (Form)
import Text
import Html exposing (Html)
import Signal exposing (Signal)

type alias Model = (Int,Int)

main : Signal Html
main = Signal.constant (view (0,0))

view : Model -> Html
view pointer = C.collage 1000 748 (forms pointer) |> Html.fromElement

forms : Model -> List Form
forms pointer = 
  [
    C.toForm background,
    C.text (Text.fromString (toString pointer))
  ]

background = E.image 1000 748 "../images/solarsystem.png"
