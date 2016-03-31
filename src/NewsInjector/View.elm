module NewsInjector.View (view) where

import Html exposing (Html)
import Html.Attributes as Attr
import LandscapeCss exposing (beAt)
import Signal exposing (Address)
import Model exposing (ApplicationState)
import Action exposing (Action)


view : Address Action -> ApplicationState -> List Html
view address state =
  if state.newsInjector.isAThing then
    [ Html.textarea
        []
        []
    ]
  else
    []
