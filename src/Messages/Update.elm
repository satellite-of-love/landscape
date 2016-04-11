module Messages.Update (seeTheWorld, respondToActions, spyOnNews, spyOnOutgoingNews, spyOnActions, takeChunder) where

import Model exposing (Model, ApplicationState, OutsideWorld, keysPressed, printableKeysDown, betterFromCode)
import Action exposing (Action(..), News(Click), OutgoingNews)
import Char exposing (KeyCode)
import Set exposing (Set)
import String
import Serialization
import Json.Encode
import Messages exposing (Message, importances, removeVisibility, addVisibility)
import Clock exposing (Clock)


addMessages : List Message -> ApplicationState -> ApplicationState
addMessages more model =
  { model
    | messages =
        more ++ model.messages
  }


takeNotice : Clock -> String -> ApplicationState -> ApplicationState
takeNotice clock message model =
  addMessages [ Message Messages.notice clock message ] model


takeChunder : Clock -> String -> ApplicationState -> ApplicationState
takeChunder clock message model =
  addMessages [ Message Messages.chunder clock message ] model


takeSave : Clock -> OutgoingNews -> ApplicationState -> ApplicationState
takeSave clock message model =
  let
    json =
      Serialization.encodeOutgoingNews message
  in
    addMessages [ Message Messages.save clock (Json.Encode.encode 1 json) ] model


spyOnOutgoingNews : Clock -> OutgoingNews -> ApplicationState -> ApplicationState
spyOnOutgoingNews clock news state =
  state |> takeSave clock news


spyOnActions : Clock -> Action -> ApplicationState -> ApplicationState
spyOnActions clock action state =
  case action of
    --Disvisiblate imp ->
    --  state |> takeChunder clock ("don't see " ++ imp.name)
    --Envisiblate imp ->
    --  state |> takeChunder clock ("do see " ++ imp.name)
    --ReceiveText _ ->
    --  state |> takeChunder clock (toString action)
    _ ->
      state |> takeNotice clock (toString action)


spyOnNews : Clock -> OutsideWorld -> News a b -> ApplicationState -> ApplicationState
spyOnNews clock world news state =
  case news of
    Click ->
      state
        |> takeChunder
            clock
            ("Click: "
              ++ (toString (world.pointer))
              ++ (descriptionOfKeys world)
            )

    _ ->
      let
        notificationsOfKeyPresses =
          keysPressed world
            |> Set.toList
            |> List.map betterFromCode
            |> List.map ((++) "Press: ")
      in
        List.foldl (takeChunder clock) state notificationsOfKeyPresses


seeTheWorld : News a b -> OutsideWorld -> List Action
seeTheWorld world news =
  []


respondToActions : Action -> ApplicationState -> ApplicationState
respondToActions action state =
  case action of
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
