module Landscape.View (landscapePane) where

import Text
import Html exposing (Html)
import Html.Attributes as Attr
import Model exposing (ApplicationState)
import Landscape exposing (InformativeText)
import LandscapeCss exposing (beAt)
import Css exposing (vh, vw, asPairs)
import Landscape.Calculations exposing (transform)


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
        ++ List.map (draw transformPair) state.annotations
      )


zoomTo : Int -> Model.MousePosition -> Html.Attribute
zoomTo zoomLevel center =
  Attr.style
    [ transform zoomLevel center
    ]


draw : ( String, String ) -> InformativeText -> Html
draw transform annotation =
  let
    ( x, y ) =
      annotation.position

    positioningCss =
      beAt (y |> toFloat |> vh) (x |> toFloat |> vw)
  in
    Html.label
      [ Attr.style
          ((asPairs positioningCss) ++ [ transform ])
      ]
      [ Html.text annotation.text ]


pct i =
  (toString i) ++ "%"
