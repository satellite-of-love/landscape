module Messages.View (view) where

import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events
import Html.CssHelpers as Help
import Model exposing (Model, printableKeysDown, ApplicationState, OutsideWorld)
import LandscapeCss
import Action exposing (Action(Disvisiblate, Envisiblate))
import Messages exposing (isVisible, importances, Message, MessageVisibility, MessageImportance)
import Signal exposing (Address)


{ id, class, classList } =
  Help.namespace ""


view : Address Action -> Model -> Html
view address model =
  let
    state =
      model.state
  in
    Html.aside
      []
      [ whereAmI model
      , visibility address state
      , messagePane state.messageVisibility state.messages
      ]


visibility : Address Action -> ApplicationState -> Html
visibility address model =
  Html.div
    []
    (List.map (makeButton address (isVisible model.messageVisibility)) importances)


makeButton : Address Action -> (MessageImportance -> Bool) -> MessageImportance -> Html
makeButton address isVisible importance =
  let
    ( buttonClass, event ) =
      if isVisible importance then
        ( LandscapeCss.CurrentlyVisible, Disvisiblate )
      else
        ( LandscapeCss.CurrentlyInvisible, Envisiblate )
  in
    Html.button
      [ class [ buttonClass ]
      , Html.Events.onClick address (event importance)
      ]
      [ Html.text importance.name ]


whereAmI : Model -> Html
whereAmI model =
  Html.div
    []
    [ output ("clock: " ++ (toString model.clock))
    , output ("mouse: " ++ (toString model.world.pointer))
    , output ("zoom: " ++ (toString model.state.whereAmI.zoom))
    , output ("keys: " ++ (printableKeysDown model.world))
    ]


output : String -> Html
output whatToSay =
  Html.div
    [ class [ LandscapeCss.WhereAmI ] ]
    [ Html.output
        []
        [ Html.text whatToSay
        ]
    ]


messagePane : MessageVisibility -> List Message -> Html
messagePane visibility whatToSay =
  Html.ul
    []
    (whatToSay
      |> List.filter ((isVisible visibility) << .importance)
      |> List.map oneMessage
    )


oneMessage : Message -> Html
oneMessage m =
  let
    clockCycle =
      if m.importance == Messages.save then
        ""
      else
        (toString m.clock) ++ " | "
  in
    Html.li [ class [ m.importance.cssClass ] ] [ Html.text (clockCycle ++ m.say) ]
