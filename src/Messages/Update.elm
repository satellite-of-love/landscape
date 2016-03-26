module Messages.Update (messagesReact) where

import Landscape.Model exposing (Model, keysPressed, xyz)
import Landscape.Action exposing (Action(..))
import Char exposing (KeyCode)
import Set exposing (Set)
import String


addMessages : Model -> List String -> Model
addMessages model more =
  { model
    | messages =
        more ++ model.messages
  }


messagesReact : Action -> Model -> Model
messagesReact action model =
  case action of
    Click ->
      addMessages
        model
        [ "You clicked at "
            ++ (toString (xyz model))
            ++ descriptionOfKeys model
        ]

    _ ->
      let
        presses =
          Set.toList (keysPressed model)

        more =
          List.map (\s -> "you pushed " ++ (toString s)) presses
      in
        addMessages model more


descriptionOfKeys model =
  if Set.isEmpty model.keysDown then
    ""
  else
    " with keys "
      ++ String.join ", " (Set.toList (Set.map (Char.fromCode >> toString) model.keysDown))
