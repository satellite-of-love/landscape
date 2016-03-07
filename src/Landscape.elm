module Landscape (..) where

import Graphics.Element as E exposing (Element)
import Graphics.Collage as C exposing (Form)
import Text
import Html exposing (Html)
import Html.Attributes as Attr
import Signal exposing (Signal)
import Mouse
import Keyboard
import Char exposing (KeyCode)
import Set exposing (Set)


type alias MousePosition =
  ( Int, Int )


type alias Model =
  { pointer : MousePosition
  , messages : List String
  , keysDown : Set KeyCode
  , inputIsAThing : Bool
  }


init : Model
init =
  { pointer = ( 0, 0 )
  , messages = []
  , keysDown = Set.empty
  , inputIsAThing = False
  }


lANDSCAPE_H =
  768


type Action
  = MouseMove MousePosition (Set KeyCode)
  | Click


main : Signal Html
main =
  Signal.merge mousePointer mouseClicks
    |> Signal.foldp updateModel init
    |> Signal.map view


mousePointer : Signal Action
mousePointer =
  Signal.map2 MouseMove Mouse.position Keyboard.keysDown


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
        | messages =
            model.messages
              ++ [ "You clicked at "
                    ++ (toString model.pointer)
                    ++ " with keys "
                    ++ (toString (Set.map Char.fromCode model.keysDown))
                 ]
        , inputIsAThing = Set.member 'T' (Set.map Char.fromCode model.keysDown)
      }

    MouseMove spot keys ->
      { model
        | pointer = spot
        , keysDown = keys
      }


view : Model -> Html
view model =
  let
    ( x, y ) =
      model.pointer
  in
    Html.div
      []
      [ Html.div
          [ Attr.style
              [ ( "position", "absolute" )
              ]
          ]
          [ landscape model.pointer ]
      , messages model.messages
      , Html.input
          [ Attr.style
              [ ( "position", "absolute" )
              , ( "top", px y )
              , ( "left", px x )
              ]
          ]
          []
      ]


px : Int -> String
px i =
  (toString i) ++ "px"


messages : List String -> Html
messages whatToSay =
  Html.div
    [ Attr.style
        [ ( "width", "200px" )
        , ( "height", (toString lANDSCAPE_H) ++ "px" )
        , ( "border", "medium dashed green" )
        , ( "position", "relative" )
        , ( "left", "1000" )
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
