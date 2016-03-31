module TextInput.Update (seeTheWorld, inputReact) where

import Model exposing (ApplicationState, OutsideWorld, keysPressed, MousePosition)
import Action exposing (Action(NewTextInput, ReceiveText, SaveText, DiscardText), News(Click), OutgoingNews(Save))
import Landscape exposing (InformativeText)
import Char exposing (KeyCode)
import Set exposing (Set)
import String


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


inputReact : Action -> ApplicationState -> ( ApplicationState, List OutgoingNews )
inputReact action model =
  case action of
    NewTextInput position ->
      doNothing (initializeNewInput model position)

    ReceiveText something ->
      let
        ti =
          model.textInput

        new =
          { ti | contents = something }
      in
        doNothing
          { model
            | textInput = new
          }

    DiscardText ->
      doNothing (goodbyeInput model)

    SaveText ->
      if theyHaveEnteredText model then
        saveTheText model
      else
        doNothing model

    _ ->
      doNothing model


doNothing : ApplicationState -> ( ApplicationState, List OutgoingNews )
doNothing state =
  ( state, [] )


saveTheText : ApplicationState -> ( ApplicationState, List OutgoingNews )
saveTheText model =
  let
    textInput =
      model.textInput

    annotation =
      InformativeText
        textInput.contents
        (moveItOverABit textInput.position)

    newState =
      { model
        | annotations =
            model.annotations ++ [ annotation ]
      }
        |> goodbyeInput
  in
    ( newState
    , [ Save annotation ]
    )


theyHaveEnteredText model =
  model.textInput.isAThing


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
