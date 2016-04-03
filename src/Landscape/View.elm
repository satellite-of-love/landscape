module Landscape.View (landscapePane) where

import Text
import Html exposing (Html)
import Html.Attributes as Attr
import Model exposing (ApplicationState)
import Landscape exposing (InformativeText)
import LandscapeCss exposing (beAt)
import Css exposing (vh, vw, asPairs)
import Landscape.Calculations exposing (translateFunction)


landscapePane : ApplicationState -> Html
landscapePane model =
  Html.node
    "main"
    []
    ([ Html.canvas
        [ zoomTo model.z model.center ]
        []
     ]
      ++ List.map draw model.annotations
    )


zoomTo : Int -> Model.MousePosition -> Html.Attribute
zoomTo zoomLevel center =
  let
    translate =
      translateFunction zoomLevel center

    scale =
      "scale(" ++ (toString zoomLevel) ++ ")"
  in
    Attr.style
      [ ( "transform", scale ++ " " ++ translate )
      ]


draw : InformativeText -> Html
draw annotation =
  let
    ( x, y ) =
      annotation.position

    positioningCss =
      beAt (y |> toFloat |> vh) (x |> toFloat |> vw)
  in
    Html.label
      [ Attr.style
          (asPairs positioningCss)
        -- [ ( "position", "absolute" )
        -- , ( "top", (toString y) ++ "vh" )
        -- , ( "left", (toString x) ++ "vw" )
        -- ]
      ]
      [ Html.text annotation.text ]


pct i =
  (toString i) ++ "%"
