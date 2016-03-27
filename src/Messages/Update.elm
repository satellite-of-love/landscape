module Messages.Update (messagesReact, takeNotice, takeSave) where

import Landscape.Model exposing (Model, keysPressed, xyz, printableKeysDown, betterFromCode)
import Landscape.Action exposing (Action(..))
import Char exposing (KeyCode)
import Set exposing (Set)
import String
import Messages exposing (Message, MessageImportance(Notice, Chunder, Save))


addMessages : Model -> List Message -> Model
addMessages model more =
  { model
    | messages =
        more ++ model.messages
  }


takeNotice : String -> Model -> Model
takeNotice message model =
  addMessages model [ Message message Notice ]


takeSave : String -> Model -> Model
takeSave message model =
  addMessages model [ Message message Save ]


messagesReact : Action -> Model -> Model
messagesReact action model =
  case action of
    Click ->
      addMessages
        model
        [ Message
            ("Click: "
              ++ (toString (xyz model))
              ++ descriptionOfKeys model
            )
            Chunder
        ]

    Disvisiblate imp ->
      model |> takeNotice (toString action)

    _ ->
      let
        presses =
          Set.toList (keysPressed model)

        more =
          List.map
            (\s -> Message ("Press: " ++ (betterFromCode s)) Chunder)
            presses
      in
        addMessages model more

removeVisibility model importance =
  { model
  | messageVisibility = (List.filter (\s -> s != importance) model.messageVisibility) }

descriptionOfKeys model =
  if Set.isEmpty model.keysDown then
    ""
  else
    "+" ++ (printableKeysDown model)
