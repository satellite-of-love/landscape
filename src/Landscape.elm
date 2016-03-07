module Landscape (..) where

import Graphics.Element as E exposing (Element)
import Graphics.Collage as C exposing (Form)
import Text
import Html exposing (Html)
import Html.Attributes as Attr
import Signal exposing (Signal)
import Mouse


type alias MousePosition =
  ( Int, Int )


type alias Model =
  { pointer : MousePosition
  , messages : List String
  }


init : Model
init =
  { pointer = ( 0, 0 )
  , messages = []
  }


lANDSCAPE_H =
  768


type Action
  = MouseMove MousePosition
  | Click


main : Signal Html
main =
  Signal.merge mousePointer mouseClicks
    |> Signal.foldp updateModel init
    |> Signal.map view


mousePointer : Signal Action
mousePointer =
  Mouse.position
    |> Signal.map MouseMove


mouseClicks : Signal Action
mouseClicks =
  Mouse.clicks
    |> Signal.map (always Click)



-- update section


updateModel : Action -> Model -> Model
updateModel action model =
  case action of
    Click ->
      { model
        | messages = model.messages ++ [ "You clicked!" ]
      }

    MouseMove spot ->
      { model
        | pointer = spot
      }


view : Model -> Html
view model =
  Html.div
    []
    [ Html.div [ Attr.style [ ( "display", "inline-block" ), ( "*display", "inline" ), ( "border", "medium dashed blue" ) ] ] [ landscape model.pointer ]
    , messages model.messages
    ]


messages : List String -> Html
messages whatToSay =
  Html.div
    [ Attr.style
        [ ( "width", "200px" )
        , ( "height", (toString lANDSCAPE_H) ++ "px" )
        , ( "border", "medium dashed green" )
        , ( "display", "inline-block" )
        , ( "*display", "inline" )
        , ( "vertical-align", "top" )
        ]
    ]
    (List.map (\a -> Html.li [] [ Html.text a ]) whatToSay)


landscape : MousePosition -> Html
landscape model =
  C.collage 1000 lANDSCAPE_H (forms model) |> Html.fromElement


forms : MousePosition -> List Form
forms model =
  [ C.toForm background
  , C.text (Text.fromString (toString model))
  ]


background =
  E.image 1000 lANDSCAPE_H "images/solarsystem.png"
