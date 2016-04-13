module Landscape.View (view) where

import Text
import Html exposing (Html)
import Html.Attributes as Attr
import Model exposing (ApplicationState)
import Landscape exposing (InformativeText, ZoomLevel, LandscapeCenter)
import LandscapeCss exposing (beAt)
import Css exposing (vh, vw, asPairs)
import Landscape.Calculations exposing (..)


view : ApplicationState -> Html
view state =
  Html.node
    "main"
    []
    ([ Html.canvas [ Attr.style [ transform state.z state.center ] ] []
     ]
      ++ List.map (draw state.z state.center) state.annotations
    )


zoomTo : ZoomLevel -> Model.MousePosition -> Html.Attribute
zoomTo zoomLevel center =
  Attr.style
    [ transform zoomLevel center
    ]


anchorX =
  35


anchorY =
  50


draw : ZoomLevel -> LandscapeCenter -> InformativeText -> Html
draw z center annotation =
  let
    ( x, y ) =
      annotation.position

    positioningCss =
      beAt (anchorY |> toFloat |> vh) (anchorX |> toFloat |> vw)
  in
    Html.label
      [ Attr.style
          ((asPairs positioningCss) ++ [ transformText z center annotation.position ])
      ]
      [ Html.text annotation.text ]


pct i =
  (toString i) ++ "%"
