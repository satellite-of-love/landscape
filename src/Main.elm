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
import Action exposing (Action, News(..), OutgoingNews)
import Landscape.View
import Landscape.Update
import Messages.Update
import Messages.View
import TextInput.Update
import TextInput.View
import NewsInjector.Update
import NewsInjector.View


main : Signal Html
main =
  Signal.mergeMany [ mousePointer, mouseClicks, newsFromTheView.signal ]
    |> Signal.foldp updateModel Model.init
    |> Signal.map (view (Signal.forwardTo newsFromTheView.address DoThis))


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


updateModel : News Action OutgoingNews -> Model -> Model
updateModel news model =
  let
    world =
      retainOutsideWorld news model.world

    actions =
      respondToNews news world

    ( state, outgoingNews ) =
      List.foldl respondToAction ( model.state, [] ) actions

    finalState =
      List.foldl Messages.Update.spyOnOutgoingNews state outgoingNews
  in
    { world = world, state = finalState }


respondToNews : News Action OutgoingNews -> OutsideWorld -> List Action
respondToNews news world =
  (Landscape.Update.seeTheWorld news world)
    ++ (Messages.Update.seeTheWorld news world)
    ++ (TextInput.Update.seeTheWorld news world)
    ++ (NewsInjector.Update.seeTheWorld news world)
    ++ (explicitActions news)


respondToAction : Action -> ( ApplicationState, List OutgoingNews ) -> ( ApplicationState, List OutgoingNews )
respondToAction action ( state, outgoingNews ) =
  ( state, outgoingNews )
    |> updateOneIgnoreAnother (Messages.Update.messagesReact action)
    |> updateOneSumAnother (TextInput.Update.inputReact action)
    |> updateOneIgnoreAnother (Landscape.Update.update action)
    |> updateOneIgnoreAnother (NewsInjector.Update.update action)


updateOneIgnoreAnother : (b -> b) -> (( b, c ) -> ( b, c ))
updateOneIgnoreAnother f ( one, another ) =
  ( f one, another )


updateOneSumAnother : (b -> ( b, List c )) -> (( b, List c ) -> ( b, List c ))
updateOneSumAnother f ( one, others ) =
  let
    ( newOne, moreOthers ) =
      f one
  in
    ( newOne, others ++ moreOthers )


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
    ([ Landscape.View.landscapePane model.state ]
      ++ [ Messages.View.view address model ]
      ++ (TextInput.View.possibleInput address model.state)
      ++ NewsInjector.View.view address model.state
    )
