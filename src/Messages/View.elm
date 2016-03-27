module Messages.View (view) where

import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events
import Html.CssHelpers as Help
import Landscape.Model exposing (Model, printableKeysDown)
import LandscapeCss
import Action exposing (Action(Disvisiblate, Envisiblate))
import Messages exposing (isVisible, importances, Message, MessageVisibility, MessageImportance)
import Signal exposing (Address)


{ id, class, classList } =
  Help.namespace ""


view : Address Action -> Model -> Html
view address model =
  Html.aside
    []
    [ whereAmI model
    , visibility address model
    , messagePane model.messageVisibility model.messages
    ]


visibility : Address Action -> Model -> Html
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
    [ output ("mouse: " ++ (toString model.pointer))
    , output ("zoom: " ++ (toString model.z))
    , output ("keys: " ++ (printableKeysDown model))
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
  Html.li [ class [ m.importance.cssClass ] ] [ Html.text m.say ]
