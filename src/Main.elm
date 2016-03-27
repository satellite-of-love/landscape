module Main (main) where

import Html exposing (Html)
import Html.Attributes as Attr
import Signal exposing (Signal)
import Window
import Mouse
import Keyboard
import Char exposing (KeyCode)
import Set exposing (Set)
import Landscape.Model exposing (Model, MousePosition)
import Action exposing (Action(..))
import Landscape.View
import Landscape.Update
import Messages.Update exposing (messagesReact)
import Messages.View
import TextInput.Update exposing (inputReact)
import TextInput.View


main : Signal Html
main =
  Signal.mergeMany [ mousePointer, mouseClicks, newsFromTheView.signal ]
    |> Signal.foldp updateModel Landscape.Model.init
    |> Signal.map (view newsFromTheView.address)


newsFromTheView : Signal.Mailbox Action
newsFromTheView =
  Signal.mailbox NoOp


mousePointer : Signal Action
mousePointer =
  Signal.map2 MouseMove relativeMousePosition Keyboard.keysDown


relativeMousePosition : Signal MousePosition
relativeMousePosition =
  Signal.map3 relativize Mouse.position Window.width Window.height


relativize : MousePosition -> Int -> Int -> MousePosition
relativize ( x, y ) w h =
  ( x * 100 // w, y * 100 // h )


mouseClicks : Signal Action
mouseClicks =
  Mouse.clicks
    |> Signal.map (always Click)


updateModel : Action -> Model -> Model
updateModel action model =
  model
    |> retainOutsideWorld action
    |> Messages.Update.messagesReact action
    |> inputReact action
    |> Landscape.Update.update action


retainOutsideWorld action model =
  case action of
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
