module TextInput.Update (seeTheWorld, inputReact) where

import Model exposing (ApplicationState, OutsideWorld, keysPressed, InformativeText, MousePosition)
import Action exposing (Action(NewTextInput, ReceiveText, SaveText, DiscardText), News(Click))
import Char exposing (KeyCode)
import Set exposing (Set)
import String
import Messages.Update exposing (takeSave)


seeTheWorld : News Action -> OutsideWorld -> List Action
seeTheWorld news model =
  case news of
    Click ->
      if theyAreHoldingT model then
        [ NewTextInput model.pointer ]
      else
        []

    _ ->
      if theyPushedEscape model then
        [ DiscardText ]
      else if theyPushedEnter model then
        [ SaveText ]
      else
        []


inputReact : Action -> ApplicationState -> ApplicationState
inputReact action model =
  case action of
    NewTextInput position ->
      initializeNewInput model position

    ReceiveText something ->
      let
        ti =
          model.textInput

        new =
          { ti | contents = something }
      in
        { model
          | textInput = new
        }

    DiscardText ->
      goodbyeInput model

    SaveText ->
      saveTheText model

    _ ->
      model


saveTheText : ApplicationState -> ApplicationState
saveTheText model =
  let
    textInput =
      model.textInput
  in
    if textInput.isAThing then
      let
        annotation =
          InformativeText
            textInput.contents
            (moveItOverABit textInput.position)
      in
        { model
          | annotations =
              model.annotations ++ [ annotation ]
        }
          |> goodbyeInput
          |> takeSave (toString annotation)
    else
      model


moveItOverABit : MousePosition -> MousePosition
moveItOverABit ( x, y ) =
  ( x, y - 2 )


initializeNewInput : ApplicationState -> MousePosition -> ApplicationState
initializeNewInput model position =
  { model
    | textInput =
        { isAThing = True
        , contents = ""
        , position = position
        }
  }


goodbyeInput : ApplicationState -> ApplicationState
goodbyeInput model =
  { model
    | textInput =
        { isAThing = False
        , contents = ""
        , position = ( 0, 0 )
        }
  }


theyAreHoldingT model =
  Set.member 'T' (Set.map Char.fromCode model.keysDown)


theyPushedEscape model =
  Set.member 27 model.keysDown


theyPushedEnter model =
  Set.member 13 model.keysDown
