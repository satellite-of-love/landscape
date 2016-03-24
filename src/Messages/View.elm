module Messages.View (messagePane) where

import Html exposing (Html)
import Html.Attributes as Attr


messagePane : Int -> List String -> Html
messagePane height whatToSay =
  Html.aside
    []
    [ Html.ul [] (List.map (\a -> Html.li [] [ Html.text a ]) whatToSay) ]
