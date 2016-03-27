module Messages.View (view) where

import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events
import Html.CssHelpers
import Landscape.Model exposing (Model, printableKeysDown)
import LandscapeCss
import Landscape.Action exposing (Action(Disvisiblate, Envisiblate))
import Messages exposing (isVisible, importancesWithDescriptions, Message, MessageVisibility, MessageImportance(Save, Chunder, Notice))
import Signal exposing (Address)


{ id, class, classList } =
  Html.CssHelpers.withNamespace ""


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
    (List.map (makeButton address (isVisible model.messageVisibility)) importancesWithDescriptions)


makeButton : Address Action -> (MessageImportance -> Bool) -> ( MessageImportance, String ) -> Html
makeButton address isVisible ( importance, description ) =
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
      [ Html.text description ]


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
  case m.importance of
    Chunder ->
      Html.li [ class [ LandscapeCss.Chunder ] ] [ Html.text m.say ]

    Notice ->
      Html.li [ class [ LandscapeCss.Notice ] ] [ Html.text m.say ]

    Save ->
      Html.li [ class [ LandscapeCss.Save ] ] [ Html.text m.say ]
