module Messages.View (view) where

import Html exposing (Html)
import Html.Attributes as Attr
import Html.CssHelpers
import Landscape.Model exposing (Model, printableKeysDown)
import LandscapeCss exposing (CssClass(..))


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
    [ class [ WhereAmI ] ]
    [ Html.output
        []
        [ Html.text whatToSay
        ]
    ]


messagePane : List String -> Html
messagePane whatToSay =
  Html.ul [] (List.map (\a -> Html.li [] [ Html.text a ]) whatToSay)
