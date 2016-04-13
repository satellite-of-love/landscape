module Main (main) where

import Html exposing (Html)
import Html.Attributes as Attr
import Signal exposing (Signal)
import Window
import Mouse
import Keyboard
import Char exposing (KeyCode)
import Set exposing (Set)
import Model exposing (Model, MousePosition, OutsideWorld, ApplicationState)
import Clock exposing (Clock)
import Action exposing (Action, News(..), OutgoingNews)
import Update exposing (updateModel)
import Landscape.View
import Messages.View
import TextInput.View
import NewsInjector.View
import Serialization
import Json.Encode


app =
  let
    input =
      Signal.mergeMany [ mousePointer, mouseClicks, newsFromTheView.signal ]

    modelAndNews =
      input
        |> Signal.foldp (dropTheSecondInput updateModel) ( Model.init, [] )
  in
    { modelSignal = Signal.map fst modelAndNews
    , outgoingNews = Signal.map snd modelAndNews
    }


main : Signal Html
main =
  app.modelSignal
    |> Signal.map (view (Signal.forwardTo newsFromTheView.address DoThis))


dropTheSecondInput : (a -> b -> ( b, List c )) -> a -> ( b, List c ) -> ( b, List c )
dropTheSecondInput f a ( b, c ) =
  f a b



------
-- outgoing signals
------


port out : Signal (List Json.Encode.Value)
port out =
  app.outgoingNews |> Signal.map (List.map Serialization.encodeOutgoingNews)



-------
-- Incoming signals
-------


newsFromTheView : Signal.Mailbox (News Action OutgoingNews)
newsFromTheView =
  Signal.mailbox NoOp


mousePointer : Signal (News a b)
mousePointer =
  Signal.map2 MouseMove relativeMousePosition Keyboard.keysDown


relativeMousePosition : Signal MousePosition
relativeMousePosition =
  Signal.map3 relativize Mouse.position Window.width Window.height


relativize : MousePosition -> Int -> Int -> MousePosition
relativize ( x, y ) w h =
  ( x * 100 // w, y * 100 // h )


mouseClicks : Signal (News a b)
mouseClicks =
  Mouse.clicks
    |> Signal.map (always Click)



-----
-- VIEW
-----


view : Signal.Address Action -> Model -> Html
view address model =
  Html.div
    []
    ([ Landscape.View.view model.state ]
      ++ [ Messages.View.view address model ]
      ++ TextInput.View.view address model.state
      ++ NewsInjector.View.view address model.state
    )
