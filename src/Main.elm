module Main (main) where

import Html exposing (Html)
import Html.Attributes as Attr
import Signal exposing (Signal)
import Window
import Mouse
import Keyboard
import Char exposing (KeyCode)
import Set exposing (Set)
import Model exposing (Model, MousePosition)
import Action exposing (Action, News(..))
import Landscape.View
import Landscape.Update
import Messages.Update exposing (messagesReact)
import Messages.View
import TextInput.Update exposing (inputReact)
import TextInput.View


main : Signal Html
main =
  Signal.mergeMany [ mousePointer, mouseClicks, newsFromTheView.signal ]
    |> Signal.foldp updateModel Model.init
    |> Signal.map (view (Signal.forwardTo newsFromTheView.address DoThis))


newsFromTheView : Signal.Mailbox (News Action)
newsFromTheView =
  Signal.mailbox NoOp


mousePointer : Signal (News a)
mousePointer =
  Signal.map2 MouseMove relativeMousePosition Keyboard.keysDown


relativeMousePosition : Signal MousePosition
relativeMousePosition =
  Signal.map3 relativize Mouse.position Window.width Window.height


relativize : MousePosition -> Int -> Int -> MousePosition
relativize ( x, y ) w h =
  ( x * 100 // w, y * 100 // h )


mouseClicks : Signal (News a)
mouseClicks =
  Mouse.clicks
    |> Signal.map (always Click)


updateModel : News Action -> Model -> Model
updateModel news model =
  let
    model =
      retainOutsideWorld news model

    actions : List Action
    actions =
      (Landscape.Update.seeTheWorld news model)
        ++ (Messages.Update.seeTheWorld news model)
        ++ (TextInput.Update.seeTheWorld news model)
        ++ (explicitActions news)
  in
    List.foldl respondToAction model actions


respondToAction : Action -> Model -> Model
respondToAction action model =
  model
    |> Messages.Update.messagesReact action
    |> inputReact action
    |> Landscape.Update.update action


explicitActions news =
  case news of
    DoThis action ->
      [ action ]

    _ ->
      []


retainOutsideWorld news model =
  case news of
    MouseMove spot keys ->
      let
        before =
          model.keysDown
      in
        { model
          | pointer = spot
          , keysDown = keys
          , previousKeysDown = before
        }

    _ ->
      model


view : Signal.Address Action -> Model -> Html
view address model =
  Html.div
    []
    ([ Landscape.View.landscapePane model
     , Messages.View.view address model
     ]
      ++ (TextInput.View.possibleInput address model)
    )
