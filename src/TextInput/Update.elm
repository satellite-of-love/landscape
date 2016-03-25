module TextInput.Update (inputReact) where

import Landscape.Model exposing (Model, keysPressed, InformativeText)
import Landscape.Action exposing (Action(..))
import Char exposing (KeyCode)
import Set exposing (Set)
import String


inputReact action model =
  case action of
    Click ->
      if theyAreHoldingT model then
        initializeNewInput model
      else
        model

    TypedSomething something ->
      let
        ti = model.textInput
        new = { ti | contents = something }
      in
        { model
          | textInput = new
        }

    _ ->
      if theyPushedEscape model then
        goodbyeInput model
      else if theyPushedEnter model then
        saveTheText model
      else
        model

saveTheText model =
  if model.textInput.isAThing then
    { model
      | annotations = model.annotations ++ [(InformativeText model.textInput.contents model.textInput.position )]
    } |> goodbyeInput
  else
    model


initializeNewInput model =
  { model
    | textInput =
        { isAThing = True
        , contents = ""
        , position = model.pointer
        }
  }


goodbyeInput model =
  { model
    | textInput =
        { isAThing = False
        , contents = ""
        , position = ( 0, 0 )
        }
  }


theyAreHoldingT model =
  Set.member 'T' (Set.map Char.fromCode model.keysDown)


theyPushedEscape model =
  Set.member 27 model.keysDown


theyPushedEnter model =
  Set.member 13 model.keysDown
