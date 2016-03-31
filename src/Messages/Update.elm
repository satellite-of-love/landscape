module Messages.Update (seeTheWorld, messagesReact, spyOnOutgoingNews, spyOnActions) where

import Model exposing (Model, ApplicationState, OutsideWorld, updateState, keysPressed, printableKeysDown, betterFromCode)
import Action exposing (Action(..), News(Click), OutgoingNews)
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


takeChunder : String -> ApplicationState -> ApplicationState
takeChunder message model =
  addMessages [ Message Messages.chunder message ] model


takeSave : String -> ApplicationState -> ApplicationState
takeSave message model =
  addMessages [ Message Messages.save message ] model


spyOnOutgoingNews : OutgoingNews -> ApplicationState -> ApplicationState
spyOnOutgoingNews news state =
  state |> takeSave (toString news)


spyOnActions : Action -> ApplicationState -> ApplicationState
spyOnActions action state =
  case action of
    Chunder _ ->
      state

    Disvisiblate imp ->
      state |> takeChunder ("don't see " ++ imp.name)

    Envisiblate imp ->
      state |> takeChunder ("do see " ++ imp.name)

    ReceiveText _ ->
      state |> takeChunder (toString action)

    _ ->
      state |> takeNotice (toString action)


seeTheWorld : News a b -> OutsideWorld -> List Action
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
      state |> takeChunder msg

    Disvisiblate imp ->
      state |> disvisiblate imp

    Envisiblate imp ->
      state |> envisiblate imp

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
