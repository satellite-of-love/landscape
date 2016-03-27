module Messages.Update (messagesReact, takeNotice) where

import Landscape.Model exposing (Model, keysPressed, xyz, printableKeysDown, betterFromCode)
import Landscape.Action exposing (Action(..))
import Char exposing (KeyCode)
import Set exposing (Set)
import String
import Messages exposing (Message(..))


addMessages : Model -> List Message -> Model
addMessages model more =
  { model
    | messages =
        more ++ model.messages
  }


takeNotice : Model -> String -> Model
takeNotice model message =
  addMessages model [ Notice message ]


messagesReact : Action -> Model -> Model
messagesReact action model =
  case action of
    Click ->
      addMessages
        model
        [ Chunder
            ("Click: "
              ++ (toString (xyz model))
              ++ descriptionOfKeys model
            )
        ]

    _ ->
      let
        presses =
          Set.toList (keysPressed model)

        more =
          List.map
            (\s -> Chunder ("Press: " ++ (betterFromCode s)))
            presses
      in
        addMessages model more


descriptionOfKeys model =
  if Set.isEmpty model.keysDown then
    ""
  else
    "+" ++ (printableKeysDown model)
