module NewsInjector.Update (seeTheWorld, update) where

import Action exposing (News(Click), Action(ActivateNewsInjector, DiscardNewsInjector))
import Model exposing (OutsideWorld, ApplicationState)
import Char
import Set


seeTheWorld : News a b -> OutsideWorld -> List Action
seeTheWorld news world =
  case news of
    Click ->
      if theyAreHoldingN world then
        [ ActivateNewsInjector ]
      else
        []

    _ ->
      if theyPushedEscape world then
        [ DiscardNewsInjector ]
      else
        []


update : Action -> ApplicationState -> ApplicationState
update action state =
  let
    newsInjector =
      state.newsInjector
  in
    case action of
      ActivateNewsInjector ->
        { state
          | newsInjector = { newsInjector | isAThing = True }
        }

      DiscardNewsInjector ->
        { state
          | newsInjector = { newsInjector | isAThing = False }
        }

      _ ->
        state


theyPushedEscape model =
  Set.member 27 model.keysDown


theyAreHoldingN model =
  Set.member 'N' (Set.map Char.fromCode model.keysDown)
