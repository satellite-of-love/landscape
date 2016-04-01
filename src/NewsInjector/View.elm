module NewsInjector.View (view) where

import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events exposing (targetValue)
import LandscapeCss exposing (beAt)
import Signal exposing (Address)
import Model exposing (ApplicationState)
import Action exposing (Action(NewsInjectorReceiveText))


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
        []
        [ Html.textarea
            [ Attr.style [ ( "transform", "scale(" ++ (toString zoom) ++ ")" ) ]
            , Html.Events.on "input" targetValue (Signal.message address << NewsInjectorReceiveText)
            ]
            []
        , Html.label [] [ Html.text "paste some news and hit command-enter" ]
        ]
    ]
