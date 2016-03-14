module TextInput.Update (inputReact) where

import Landscape.Model exposing (Model, keysPressed)
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

    _ ->
      if theyPushedEscape model then
        goodbyeInput model
      else if model.textInput.isAThing then
        addTypingToContent model
      else
        model


addTypingToContent model =
  let
    typing =
      keysPressed model
        |> Set.toList
        |> List.filter isPrintable
        |> List.map Char.fromCode
        |> List.map String.fromChar
        |> List.foldr (++) ""

    ti =
      model.textInput
  in
    { model
      | textInput = { ti | contents = ti.contents ++ typing }
    }


isPrintable keycode =
  keycode >= 40


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
