module Messages.View (view) where

import Html exposing (Html)
import Html.Attributes as Attr
import Html.CssHelpers
import Landscape.Model exposing (Model, printableKeysDown)
import LandscapeCss
import Messages exposing (Message(..))


{ id, class, classList } =
  Html.CssHelpers.withNamespace ""


view : Model -> Html
view model =
  Html.aside
    []
    [ whereAmI model
    , messagePane model.messages
    ]


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
  case m of
    Chunder message ->
      Html.li [ class [ LandscapeCss.Chunder ] ] [ Html.text message ]

    Notice message ->
      Html.li [ class [ LandscapeCss.Notice ] ] [ Html.text message ]

    Save message ->
      Html.li [ class [ LandscapeCss.Save ] ] [ Html.text message ]
