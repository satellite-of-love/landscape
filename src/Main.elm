module Main (main) where

import Html exposing (Html)
import Html.Attributes as Attr
import Signal exposing (Signal)
import Mouse
import Keyboard
import Char exposing (KeyCode)
import Set exposing (Set)
import Landscape.Model exposing (Model, MousePosition)
import Landscape.Action exposing (Action(..))
import Landscape.View exposing (landscapePane)
import Messages.Update exposing (messagesReact)
import Messages.View exposing (messagePane)
import TextInput.Update exposing (inputReact)
import TextInput.View exposing (possibleInput)


lANDSCAPE_H =
  768


main : Signal Html
main =
  Signal.merge mousePointer mouseClicks
    |> Signal.foldp updateModel Landscape.Model.init
    |> Signal.map (view newsFromTheView.address)


newsFromTheView : Signal.Mailbox Action
newsFromTheView =
  Signal.mailbox NoOp


mousePointer : Signal Action
mousePointer =
  Signal.map2 MouseMove Mouse.position Keyboard.keysDown


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
    ([ landscapePane lANDSCAPE_H model
     , Messages.View.messagePane lANDSCAPE_H model.messages
     ]
      ++ (possibleInput address model)
    )
