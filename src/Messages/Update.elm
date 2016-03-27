module Messages.Update (messagesReact, takeNotice, takeSave) where

import Landscape.Model exposing (Model, keysPressed, xyz, printableKeysDown, betterFromCode)
import Landscape.Action exposing (Action(..))
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


messagesReact : Action -> Model -> Model
messagesReact action model =
  case action of
    Click ->
      addMessages
        model
        [ Message
            Messages.chunder
            ("Click: "
              ++ (toString (xyz model))
              ++ descriptionOfKeys model
            )
        ]

    Disvisiblate imp ->
      model |> takeNotice (toString action) |> disvisiblate imp

    Envisiblate imp ->
      model |> takeNotice (toString action) |> envisiblate imp

    _ ->
      let
        presses =
          Set.toList (keysPressed model)

        more =
          List.map
            (betterFromCode >> (++) "Press: " >> Message Messages.chunder)
            presses
      in
        addMessages model more


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
