module Messages.Update (seeTheWorld, messagesReact, takeNotice, takeSave) where

import Model exposing (Model, ApplicationState, OutsideWorld, updateState, keysPressed, printableKeysDown, betterFromCode)
import Action exposing (Action(..), News(Click))
import Char exposing (KeyCode)
import Set exposing (Set)
import String
import Messages exposing (Message, importances, removeVisibility, addVisibility)


addMessages : List Message -> ApplicationState -> ApplicationState
addMessages more model =
  { model
    | messages =
        more ++ model.messages
  }


takeNotice : String -> ApplicationState -> ApplicationState
takeNotice message model =
  addMessages [ Message Messages.notice message ] model


takeSave : String -> ApplicationState -> ApplicationState
takeSave message model =
  addMessages [ Message Messages.save message ] model


seeTheWorld : News Action -> OutsideWorld -> List Action
seeTheWorld news world =
  case news of
    Click ->
      [ Chunder
          ("Click: "
            ++ (toString (world.pointer))
            ++ (descriptionOfKeys world)
          )
      ]

    _ ->
      let
        notifactionsOfKeyPresses =
          keysPressed world
            |> Set.toList
            |> List.map betterFromCode
            |> List.map ((++) "Press: ")
      in
        List.map Chunder notifactionsOfKeyPresses


messagesReact : Action -> ApplicationState -> ApplicationState
messagesReact action state =
  case action of
    Chunder msg ->
      addMessages
        [ Message Messages.chunder msg
        ]
        state

    Disvisiblate imp ->
      state |> takeNotice (toString action) |> disvisiblate imp

    Envisiblate imp ->
      state |> takeNotice (toString action) |> envisiblate imp

    NewTextInput pos ->
      state |> takeNotice ("New input field at " ++ (toString (toString pos)))

    _ ->
      state


disvisiblate imp model =
  { model
    | messageVisibility = removeVisibility imp model.messageVisibility
  }


envisiblate imp model =
  { model
    | messageVisibility = addVisibility imp model.messageVisibility
  }


descriptionOfKeys : OutsideWorld -> String
descriptionOfKeys world =
  if Set.isEmpty world.keysDown then
    ""
  else
    "+" ++ (printableKeysDown world)


xyz : Model -> ( Int, Int, Int )
xyz model =
  let
    ( x, y ) =
      model.world.pointer
  in
    ( x, y, model.state.z )
