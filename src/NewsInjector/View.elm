module NewsInjector.View (view) where

import Html exposing (Html)
import Html.Attributes as Attr
import LandscapeCss exposing (beAt)
import Signal exposing (Address)
import Model exposing (ApplicationState)
import Action exposing (Action)


view : Address Action -> ApplicationState -> List Html
view address state =
  let
    zoom =
      if state.newsInjector.isAThing then
        1.0
      else
        0.0
  in
    [ Html.textarea
        [ Attr.style [ ( "transform", "scale(" ++ (toString zoom) ++ ")" ) ] ]
        []
    ]
