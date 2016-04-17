module Landscape.View (view) where

import Text
import Html exposing (Html)
import Html.Attributes as Attr
import Model exposing (ApplicationState, PositionOnScreen)
import Landscape exposing (InformativeText, ZoomLevel, PositionInDrawing, WhereAmI)
import LandscapeCss exposing (beAt)
import Css exposing (vh, vw, asPairs)
import Landscape.Calculations as Calculations


view : ApplicationState -> Html
view state =
  Html.node
    "main"
    []
    ([ Html.canvas [ Attr.style [ Calculations.transform state.whereAmI ] ] []
     ]
      ++ List.map (draw state.whereAmI) state.annotations
    )


anchorX =
  35


anchorY =
  50


draw : WhereAmI -> InformativeText -> Html
draw pos annotation =
  let
    positioningCss =
      (asPairs (beAt (anchorY |> toFloat |> vh) (anchorX |> toFloat |> vw))) ++ [ Calculations.transformText pos annotation.position ]
  in
    Html.label
      [ Attr.style
          positioningCss
      ]
      [ Html.text annotation.text ]


pct i =
  (toString i) ++ "%"
