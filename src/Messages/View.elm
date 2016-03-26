module Messages.View (view) where

import Html exposing (Html)
import Html.Attributes as Attr
import Landscape.Model exposing (Model)


view : Model -> Html
view model =
  Html.aside
    []
    [ messagePane model.messages ]


messagePane : List String -> Html
messagePane whatToSay =
  Html.ul [] (List.map (\a -> Html.li [] [ Html.text a ]) whatToSay)
