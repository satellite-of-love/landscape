module Messages.Update (messagesReact) where

import Landscape.Model exposing (Model, keysPressed)
import Landscape.Action exposing (Action(..))
import Char exposing (KeyCode)
import Set exposing (Set)


messagesReact : Action -> Model -> Model
messagesReact action model =
  case action of
    Click ->
      { model
        | messages =
            model.messages
              ++ [ "You clicked at "
                    ++ (toString model.pointer)
                    ++ " with keys "
                    ++ (toString (Set.map Char.fromCode model.keysDown))
                 ]
      }

    _ ->
      let
        presses =
          keysPressed model
      in
        if Set.isEmpty presses then
          model
        else
          { model
            | messages =
                model.messages ++ [ "jhgfkhgdkhtdkf" ]
          }
