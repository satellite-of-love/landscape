module Messages.View (messagePane) where

import Html exposing (Html)
import Html.Attributes as Attr


messagePane : Int -> List String -> Html
messagePane height whatToSay =
  Html.aside
    [ Attr.style
        [ ( "width", "200px" )
        , ( "height", "100%" )
        , ( "border", "medium dashed green" )
        , ( "position", "relative" )
        , ( "left", "1000" )
        , ( "vertical-align", "top" )
        , ( "overflow", "scroll" )
        ]
    ]
    (List.map (\a -> Html.li [] [ Html.text a ]) whatToSay)
