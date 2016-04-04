module TextInput.Update (seeTheWorld, inputReact) where

import Model exposing (ApplicationState, OutsideWorld, keysPressed, MousePosition)
import Action exposing (Action(NewTextInput, ReceiveText, SaveText, DiscardText), News(Click, ServerSays), OutgoingNews(Save))
import Landscape exposing (InformativeText)
import Char exposing (KeyCode)
import Set exposing (Set)
import String


seeTheWorld : News Action OutgoingNews -> OutsideWorld -> List Action
seeTheWorld news world =
  case news of
    ServerSays (Save informativeText) ->
      -- this is kinda cheating, but let's simulate entering it
      [ NewTextInput informativeText.position
      , ReceiveText informativeText.text
      , SaveText
      ]

    Click ->
      if theyAreHoldingT world then
        [ NewTextInput world.pointer ]
      else
        []

    _ ->
      if theyPushedEscape world then
        [ DiscardText ]
      else if theyPushedEnter world then
        [ SaveText ]
      else
        []


inputReact : Action -> ApplicationState -> ( ApplicationState, List OutgoingNews )
inputReact action state =
  case action of
    NewTextInput position ->
      doNothing (initializeNewInput state position)

    ReceiveText something ->
      let
        ti =
          state.textInput

        new =
          { ti | contents = something }
      in
        doNothing
          { state
            | textInput = new
          }

    DiscardText ->
      doNothing (goodbyeInput state)

    SaveText ->
      if theyHaveEnteredText state then
        saveTheText state
      else
        doNothing state

    _ ->
      doNothing state


doNothing : ApplicationState -> ( ApplicationState, List OutgoingNews )
doNothing state =
  ( state, [] )


saveTheText : ApplicationState -> ( ApplicationState, List OutgoingNews )
saveTheText state =
  let
    textInput =
      state.textInput

    annotation =
      InformativeText
        textInput.contents
        (moveItOverABit textInput.position)
        state.z

    newState =
      { state
        | annotations =
            state.annotations ++ [ annotation ]
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


theyAreHoldingT world =
  Set.member 'T' (Set.map Char.fromCode world.keysDown)


theyPushedEscape : OutsideWorld -> Bool
theyPushedEscape world =
  Set.member 27 (keysPressed world)


theyPushedEnter world =
  Set.member 13 (keysPressed world)
