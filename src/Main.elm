module Main (main) where

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
import Landscape.Model exposing (Model, MousePosition)
import Landscape.Action exposing (Action)


lANDSCAPE_H =
  768


type Action
  = MouseMove MousePosition (Set KeyCode)
  | Click


main : Signal Html
main =
  Signal.merge mousePointer mouseClicks
    |> Signal.foldp updateModel Landscape.Model.init
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
  model
    |> messagesReact action
    |> inputReact action


messagesReact : Action -> Model -> Model
messagesReact action model =
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
        , textInput =
            { isAThing = Set.member 'T' (Set.map Char.fromCode model.keysDown)
            , contents = ""
            , position = model.pointer
            }
      }

    _ ->
      model


inputReact action model =
  case action of
    MouseMove spot keys ->
      { model
        | pointer = spot
        , keysDown = keys
      }

    _ ->
      model


view : Model -> Html
view model =
  Html.div
    []
    ([ Html.div
        [ Attr.style
            [ ( "position", "absolute" )
            ]
        ]
        [ landscape model.pointer ]
     , messages model.messages
     ]
      ++ (possibleInput model)
    )


possibleInput : Model -> List Html
possibleInput model =
  if model.textInput.isAThing then
    [ input model.textInput ]
  else
    []


input textInputModel =
  let
    ( x, y ) =
      textInputModel.position
  in
    Html.input
      [ Attr.style
          [ ( "position", "absolute" )
          , ( "top", px y )
          , ( "left", px x )
          ]
      ]
      []


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
