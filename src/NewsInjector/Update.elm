module NewsInjector.Update (seeTheWorld, update) where

import Action exposing (News(Click), Action(InjectTheNews, ActivateNewsInjector, DiscardNewsInjector))
import Model exposing (OutsideWorld, ApplicationState, keysPressed)
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
      else if theyPushedEnter world && theyAreHoldingCommand world then
        [ InjectTheNews ]
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


theyPushedEscape world =
  Set.member 27 (keysPressed world)


theyPushedEnter world =
  Set.member 13 (keysPressed world)


theyAreHoldingN world =
  Set.member 'N' (Set.map Char.fromCode world.keysDown)


theyAreHoldingCommand world =
  Set.member 91 world.keysDown
