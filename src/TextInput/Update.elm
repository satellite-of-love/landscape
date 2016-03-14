module TextInput.Update (inputReact) where

import Landscape.Model exposing (Model)
import Landscape.Action exposing (Action(..))
import Char exposing (KeyCode)
import Set exposing (Set)


inputReact action model =
  case action of
    Click ->
      if theyAreHoldingT model then
        { model
          | textInput =
              { isAThing = True
              , contents = ""
              , position = model.pointer
              }
        }
      else
        model

    _ ->
      if theyPushedEscape model then
        { model
          | textInput =
              { isAThing = False
              , contents = ""
              , position = ( 0, 0 )
              }
        }
      else
        model


theyAreHoldingT model =
  Set.member 'T' (Set.map Char.fromCode model.keysDown)


theyPushedEscape model =
  Set.member 27 model.keysDown
