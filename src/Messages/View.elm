module Messages.View (view) where

import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events
import Html.CssHelpers
import Landscape.Model exposing (Model, printableKeysDown)
import LandscapeCss
import Landscape.Action exposing (Action(Disvisiblate))
import Messages exposing (isVisible, Message, MessageVisibility, MessageImportance(Save, Chunder, Notice))
import Signal exposing (Address)


{ id, class, classList } =
  Html.CssHelpers.withNamespace ""


view : Address Action -> Model -> Html
view address model =
  Html.aside
    []
    [ whereAmI model
    , visibility address model
    , messagePane model.messages
    ]


visibility : Address Action -> Model -> Html
visibility address model =
  Html.div
    []
    (List.map (viz address model.messageVisibility) [ Chunder, Notice, Save ])


viz : Address Action -> MessageVisibility -> MessageImportance -> Html
viz address messageVisibility category =
  let
    text =
      (toString category)
  in
    if isVisible messageVisibility category then
      Html.button [ Html.Events.onClick address (Disvisiblate category) ] [ Html.text text ]
    else
      Html.s [] [ Html.text text ]


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


messagePane : List Message -> Html
messagePane whatToSay =
  Html.ul [] (List.map oneMessage whatToSay)


oneMessage : Message -> Html
oneMessage m =
  case m.importance of
    Chunder ->
      Html.li [ class [ LandscapeCss.Chunder ] ] [ Html.text m.say ]

    Notice ->
      Html.li [ class [ LandscapeCss.Notice ] ] [ Html.text m.say ]

    Save ->
      Html.li [ class [ LandscapeCss.Save ] ] [ Html.text m.say ]
