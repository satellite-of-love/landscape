module NewsInjector.View (view) where

import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events exposing (targetValue)
import LandscapeCss exposing (beAt)
import Signal exposing (Address)
import Model exposing (ApplicationState)
import Action exposing (Action(NewsInjectorReceiveText))
import LandscapeCss exposing (CssClass(NewsInjectorPane))
import Html.CssHelpers


class =
  .class (Html.CssHelpers.namespace "")


view : Address Action -> ApplicationState -> List Html
view address state =
  let
    zoom =
      if state.newsInjector.isAThing then
        1.0
      else
        0.0
  in
    [ Html.div
        [ class [ NewsInjectorPane ], Attr.style [ ( "transform", "scale(" ++ (toString zoom) ++ ")" ) ] ]
        [ Html.textarea
            [ Html.Events.on "input" targetValue (Signal.message address << NewsInjectorReceiveText)
            ]
            []
        , Html.label [] [ Html.text "paste some news and hit command-enter" ]
        ]
    ]
