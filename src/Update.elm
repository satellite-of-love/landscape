module Update (updateModel) where

import Model exposing (Model, OutsideWorld, ApplicationState)
import Clock exposing (Clock)
import Action exposing (Action, News(..), OutgoingNews)
import Landscape.Update
import Messages.Update
import TextInput.Update
import NewsInjector.Update


-----
-- UPDATE
-----


updateModel : News Action OutgoingNews -> Model -> ( Model, List OutgoingNews )
updateModel news model =
  let
    ( model, allTheNews ) =
      NewsInjector.Update.pretendThingsHappened model news
  in
    List.foldl (appendSecondOutput respondToOneNews) ( model, [] ) allTheNews


respondToOneNews : News Action OutgoingNews -> Model -> ( Model, List OutgoingNews )
respondToOneNews news model =
  let
    world =
      retainOutsideWorld news model.world

    spiedOnNews =
      Messages.Update.spyOnNews model.clock world news model.state

    actions =
      respondToNews news world

    spiedState =
      List.foldl (Messages.Update.spyOnActions model.clock) spiedOnNews actions

    ( actedState, outgoingNews ) =
      List.foldl (respondToAction model.clock) ( spiedState, [] ) actions

    finalState =
      List.foldl (Messages.Update.spyOnOutgoingNews model.clock) actedState outgoingNews
  in
    ( { world = world, state = finalState, clock = model.clock + 1 }, outgoingNews )


updateOneIgnoreAnother : (b -> b) -> (( b, c ) -> ( b, c ))
updateOneIgnoreAnother f ( one, another ) =
  ( f one, another )


appendSecondOutput : (a -> b -> ( b, List c )) -> a -> ( b, List c ) -> ( b, List c )
appendSecondOutput f a =
  updateOneSumAnother (f a)


dropTheSecondInput : (a -> b -> ( b, List c )) -> a -> ( b, List c ) -> ( b, List c )
dropTheSecondInput f a ( b, c ) =
  f a b


updateOneSumAnother : (b -> ( b, List c )) -> (( b, List c ) -> ( b, List c ))
updateOneSumAnother f ( one, others ) =
  let
    ( newOne, moreOthers ) =
      f one
  in
    ( newOne, others ++ moreOthers )


explicitActions news =
  case news of
    DoThis action ->
      [ action ]

    _ ->
      []


retainOutsideWorld news model =
  case news of
    MouseMove spot keys ->
      let
        before =
          model.keysDown
      in
        { model
          | pointer = spot
          , keysDown = keys
          , previousKeysDown = before
        }

    _ ->
      model


respondToNews : News Action OutgoingNews -> OutsideWorld -> List Action
respondToNews news world =
  (Landscape.Update.seeTheWorld news world)
    ++ (TextInput.Update.seeTheWorld news world)
    ++ (Messages.Update.seeTheWorld news world)
    ++ (NewsInjector.Update.seeTheWorld news world)
    ++ (explicitActions news)


respondToAction : Clock -> Action -> ( ApplicationState, List OutgoingNews ) -> ( ApplicationState, List OutgoingNews )
respondToAction clock action ( state, outgoingNews ) =
  ( state, outgoingNews )
    |> updateOneSumAnother (TextInput.Update.respondToActions clock action)
    |> updateOneIgnoreAnother (Landscape.Update.respondToActions action)
    |> updateOneIgnoreAnother (NewsInjector.Update.respondToActions action)
    |> updateOneIgnoreAnother (Messages.Update.respondToActions clock action)
