module Messages.Update (seeTheWorld, messagesReact, takeNotice, takeSave) where

import Model exposing (Model, keysPressed, xyz, printableKeysDown, betterFromCode)
import Action exposing (Action(Chunder, Disvisiblate, Envisiblate), News(Click))
import Char exposing (KeyCode)
import Set exposing (Set)
import String
import Messages exposing (Message, importances, removeVisibility, addVisibility)


addMessages : Model -> List Message -> Model
addMessages model more =
  { model
    | messages =
        more ++ model.messages
  }


takeNotice : String -> Model -> Model
takeNotice message model =
  addMessages model [ Message Messages.notice message ]


takeSave : String -> Model -> Model
takeSave message model =
  addMessages model [ Message Messages.save message ]


seeTheWorld : News Action -> Model -> List Action
seeTheWorld news model =
  case news of
    Click ->
      [ Chunder
          ("Click: "
            ++ (toString (xyz model))
            ++ (descriptionOfKeys model)
          )
      ]

    _ ->
      let
        notifactionsOfKeyPresses =
          keysPressed model
            |> Set.toList
            |> List.map betterFromCode
            |> List.map ((++) "Press: ")
      in
        List.map Chunder notifactionsOfKeyPresses


messagesReact : Action -> Model -> Model
messagesReact action model =
  case action of
    Chunder msg ->
      addMessages
        model
        [ Message Messages.chunder msg
        ]

    Disvisiblate imp ->
      model |> takeNotice (toString action) |> disvisiblate imp

    Envisiblate imp ->
      model |> takeNotice (toString action) |> envisiblate imp

    _ ->
      model


disvisiblate imp model =
  { model
    | messageVisibility = removeVisibility imp model.messageVisibility
  }


envisiblate imp model =
  { model
    | messageVisibility = addVisibility imp model.messageVisibility
  }


descriptionOfKeys model =
  if Set.isEmpty model.keysDown then
    ""
  else
    "+" ++ (printableKeysDown model)
