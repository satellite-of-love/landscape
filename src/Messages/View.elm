module Messages.View (messagePane) where

import Html exposing (Html)
import Html.Attributes as Attr


messagePane : Int -> List String -> Html
messagePane height whatToSay =
  Html.div
    [ Attr.style
        [ ( "width", "200px" )
        , ( "height", (toString height) ++ "px" )
        , ( "border", "medium dashed green" )
        , ( "position", "relative" )
        , ( "left", "1000" )
        , ( "vertical-align", "top" )
        ]
    ]
    (List.map (\a -> Html.li [] [ Html.text a ]) whatToSay)
