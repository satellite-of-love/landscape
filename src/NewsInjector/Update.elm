module NewsInjector.Update (seeTheWorld) where

import Action exposing (News(Click), Action(ActivateNewsInjector))
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

      _ ->
        state


theyAreHoldingN model =
  Set.member 'N' (Set.map Char.fromCode model.keysDown)
