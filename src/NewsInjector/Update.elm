module NewsInjector.Update (seeTheWorld, update, pretendThingsHappened) where

import Action exposing (News(Click, ServerSays), OutgoingNews, Action(NewsInjectorReceiveText, InjectTheNews, ActivateNewsInjector, DiscardNewsInjector))
import Model exposing (Model, OutsideWorld, ApplicationState, keysPressed)
import Char
import Set
import String
import NewsInjector exposing (NewsInjectorPane)
import Serialization
import Json.Decode


pretendThingsHappened : Model -> News Action OutgoingNews -> ( Model, List (News Action OutgoingNews) )
pretendThingsHappened model news =
  let
    newsInjector =
      model.state.newsInjector

    moreNews =
      newsInjector.pretendWeJustReceived

    state =
      model.state

    stateWithoutNews =
      { state | newsInjector = { newsInjector | pretendWeJustReceived = [] } }
  in
    ( { model | state = stateWithoutNews }, moreNews ++ [ news ] )


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
          | newsInjector = NewsInjector.init
        }

      NewsInjectorReceiveText string ->
        { state
          | newsInjector = { newsInjector | contents = string }
        }

      InjectTheNews ->
        let
          lines =
            String.split "\n" newsInjector.contents

          listOfResults =
            List.map (putOriginalInError (Json.Decode.decodeString Serialization.decodeOutgoingNews)) lines

          resultOfList =
            allOrNothing listOfResults
        in
          case resultOfList of
            Ok outgoingNewses ->
              { state
                | newsInjector =
                    { isAThing = False
                    , contents = ""
                    , pretendWeJustReceived = (List.map ServerSays outgoingNewses)
                    , error = Nothing
                    }
              }

            Err e ->
              { state | newsInjector = { newsInjector | error = Just e } }

      _ ->
        state


putOriginalInError : (String -> Result String c) -> String -> Result String c
putOriginalInError decode string =
  case decode string of
    Ok ok ->
      Ok ok

    Err e ->
      Err (e ++ " <" ++ string ++ ">")


allOrNothing : List (Result b a) -> Result b (List a)
allOrNothing =
  let
    incorporateOne : Result b a -> Result b (List a) -> Result b (List a)
    incorporateOne result accum =
      case ( accum, result ) of
        ( Err boo, _ ) ->
          Err boo

        ( _, Err boo ) ->
          Err boo

        ( Ok some, Ok oneMore ) ->
          Ok (some ++ [ oneMore ])
  in
    List.foldl incorporateOne (Ok [])


theyPushedEscape world =
  Set.member 27 (keysPressed world)


theyPushedEnter world =
  Set.member 13 (keysPressed world)


theyAreHoldingN world =
  Set.member 'N' (Set.map Char.fromCode world.keysDown)


theyAreHoldingCommand world =
  Set.member 91 world.keysDown
