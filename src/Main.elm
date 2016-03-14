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


lANDSCAPE_H =
  768


main : Signal Html
main =
  Signal.merge mousePointer mouseClicks
    |> Signal.foldp updateModel Landscape.Model.init
    |> Signal.map view


mousePointer : Signal Action
mousePointer =
  Signal.map2 MouseMove Mouse.position Keyboard.keysDown


mouseClicks : Signal Action
mouseClicks =
  Mouse.clicks
    |> Signal.map (always Click)



-- update section


updateModel : Action -> Model -> Model
updateModel action model =
  model
    |> Messages.Update.messagesReact action
    |> inputReact action


inputReact action model =
  case action of
    MouseMove spot keys ->
      { model
        | pointer = spot
        , keysDown = keys
      }

    _ ->
      model


view : Model -> Html
view model =
  Html.div
    []
    ([ landscapePane lANDSCAPE_H model
     , Messages.View.messagePane lANDSCAPE_H model.messages
     ]
      ++ (possibleInput model)
    )


possibleInput : Model -> List Html
possibleInput model =
  if model.textInput.isAThing then
    [ input model.textInput ]
  else
    []


input textInputModel =
  let
    ( x, y ) =
      textInputModel.position
  in
    Html.input
      [ Attr.style
          [ ( "position", "absolute" )
          , ( "top", px y )
          , ( "left", px x )
          ]
      ]
      []


px : Int -> String
px i =
  (toString i) ++ "px"
