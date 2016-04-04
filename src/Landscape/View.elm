module Landscape.View (landscapePane) where

import Text
import Html exposing (Html)
import Html.Attributes as Attr
import Model exposing (ApplicationState)
import Landscape exposing (InformativeText, ZoomLevel, LandscapeCenter)
import LandscapeCss exposing (beAt)
import Css exposing (vh, vw, asPairs)
import Landscape.Calculations exposing (..)


landscapePane : ApplicationState -> Html
landscapePane state =
  let
    transformPair =
      transform state.z state.center
  in
    Html.node
      "main"
      []
      ([ Html.canvas [ Attr.style [ transformPair ] ] []
       ]
        ++ List.map (draw state.z state.center) state.annotations
      )


zoomTo : ZoomLevel -> Model.MousePosition -> Html.Attribute
zoomTo zoomLevel center =
  Attr.style
    [ transform zoomLevel center
    ]


draw : ZoomLevel -> LandscapeCenter -> InformativeText -> Html
draw z center annotation =
  let
    ( x, y ) =
      annotation.position

    positioningCss =
      beAt (50 |> toFloat |> vh) (35 |> toFloat |> vw)
  in
    Html.label
      [ Attr.style
          ((asPairs positioningCss) ++ [ transformText z center annotation.position ])
      ]
      [ Html.text annotation.text ]


pct i =
  (toString i) ++ "%"
