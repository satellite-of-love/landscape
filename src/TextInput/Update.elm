module TextInput.Update (seeTheWorld, respondToActions) where

import Model exposing (ApplicationState, OutsideWorld, keysPressed, PositionOnScreen)
import Clock exposing (Clock)
import Action exposing (Action(NewTextInput, ReceiveText, SaveText, DiscardText, TheServerKnowsAbout), News(Click, ServerSays), OutgoingNews(Save, Focus))
import Landscape exposing (InformativeText)
import Char exposing (KeyCode)
import Set exposing (Set)
import String
import Messages.Update
import Landscape.Calculations as Calculations


seeTheWorld : News Action OutgoingNews -> OutsideWorld -> List Action
seeTheWorld news world =
  case news of
    ServerSays (Save informativeText) ->
      -- this is kinda cheating, but let's simulate entering it
      -- this will not work if we are currently zoomed!! or if the text was zoomed
      [ TheServerKnowsAbout informativeText ]

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


respondToActions : Clock -> Action -> ApplicationState -> ( ApplicationState, List OutgoingNews )
respondToActions clock action state =
  case action of
    NewTextInput position ->
      let
        newInputId =
          "textInput_" ++ (toString clock)
      in
        ( (initializeNewInput newInputId state position), [ Focus newInputId ] )

    ReceiveText something ->
      let
        ( correctedText, corrections ) =
          bePicky something

        stateWithMessages =
          List.foldl (Messages.Update.takeChunder clock) state corrections
      in
        stateWithMessages
          |> withTextInputContents correctedText
          |> doNothing

    DiscardText ->
      doNothing (goodbyeInput state)

    SaveText ->
      if theyHaveEnteredText state then
        saveTheText state
      else
        doNothing state

    TheServerKnowsAbout annotation ->
      { state
        | annotations =
            state.annotations ++ [ annotation ]
      }
        |> doNothing

    _ ->
      doNothing state


doNothing : ApplicationState -> ( ApplicationState, List OutgoingNews )
doNothing state =
  ( state, [] )


withTextInputContents contents state =
  let
    ti =
      state.textInput
  in
    { state
      | textInput =
          { ti | contents = contents }
    }


bePicky : String -> ( String, List String )
bePicky input =
  let
    removeOrlds =
      String.split "orld" input
  in
    case removeOrlds of
      [ one ] ->
        ( one, [] )

      _ ->
        ( String.join "rold" removeOrlds
        , [ "Fixed that for you ;-)" ]
        )


saveTheText : ApplicationState -> ( ApplicationState, List OutgoingNews )
saveTheText state =
  let
    textInput =
      state.textInput

    annotation =
      InformativeText
        textInput.contents
        (Calculations.whereIsThis state.whereAmI textInput.position)

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


initializeNewInput : String -> ApplicationState -> PositionOnScreen -> ApplicationState
initializeNewInput id model position =
  { model
    | textInput =
        { isAThing = True
        , contents = ""
        , position = position
        , id = id
        }
  }


goodbyeInput : ApplicationState -> ApplicationState
goodbyeInput model =
  { model
    | textInput =
        { isAThing = False
        , contents = ""
        , position = ( 0, 0 )
        , id = ""
        }
  }


theyAreHoldingT world =
  Set.member 'T' (Set.map Char.fromCode world.keysDown)


theyPushedEscape : OutsideWorld -> Bool
theyPushedEscape world =
  Set.member 27 (keysPressed world)


theyPushedEnter world =
  Set.member 13 (keysPressed world)
