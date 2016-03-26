module Messages.View (view) where

import Html exposing (Html)
import Html.Attributes as Attr
import Landscape.Model exposing (Model, xyz)


view : Model -> Html
view model =
  Html.aside
    []
    [ whereAmI model
    , messagePane model.messages
    ]


whereAmI : Model -> Html
whereAmI model =
  Html.output
    []
    [ Html.text (toString (xyz model))
    ]


messagePane : List String -> Html
messagePane whatToSay =
  Html.ul [] (List.map (\a -> Html.li [] [ Html.text a ]) whatToSay)
