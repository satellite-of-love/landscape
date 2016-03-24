module Messages.Update (messagesReact) where

import Landscape.Model exposing (Model, keysPressed)
import Landscape.Action exposing (Action(..))
import Char exposing (KeyCode)
import Set exposing (Set)


addMessages : Model -> List String -> Model
addMessages model more =
  { model
    | messages =
        model.messages ++ more
  }


messagesReact : Action -> Model -> Model
messagesReact action model =
  case action of
    Click ->
      addMessages
        model
        [ "You clicked at "
          ++ (toString model.pointer)
          ++ " with keys "
          ++ (toString (Set.map Char.fromCode model.keysDown))
        ]

    _ ->
      let
        presses =
          Set.toList (keysPressed model)

        more =
          List.map (\s -> "you pushed " ++ (toString s)) presses
      in
        addMessages model more
