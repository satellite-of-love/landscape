module Messages.Update (messagesReact) where

import Landscape.Model exposing (Model)
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
        , textInput =
            { isAThing = Set.member 'T' (Set.map Char.fromCode model.keysDown)
            , contents = ""
            , position = model.pointer
            }
      }

    _ ->
      model
