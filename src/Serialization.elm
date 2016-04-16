module Serialization (..) where

import Json.Encode
import Json.Decode exposing ((:=))
import Json.Decode.Extra exposing ((|:))
import Landscape exposing (InformativeText, PositionInDrawing)
import Action exposing (News(ServerSays), Action, OutgoingNews(..))


decodeNews : Json.Decode.Decoder (News Action OutgoingNews)
decodeNews =
  Json.Decode.succeed ServerSays
    |: ("serverSays" := decodeOutgoingNews)


decodeInformativeText : Json.Decode.Decoder InformativeText
decodeInformativeText =
  Json.Decode.succeed InformativeText
    |: ("text" := Json.Decode.string)
    |: ("position" := decodePosition)


decodePosition : Json.Decode.Decoder PositionInDrawing
decodePosition =
  Json.Decode.succeed PositionInDrawing
    |: ("x" := Json.Decode.int)
    |: ("y" := Json.Decode.int)
    |: ("naturalZoom" := Json.Decode.int)


decodeOutgoingNews : Json.Decode.Decoder OutgoingNews
decodeOutgoingNews =
  let
    decodeSave =
      Json.Decode.succeed Save
        |: ("save" := decodeInformativeText)

    decodeFocus =
      Json.Decode.succeed Focus
        |: ("focus" := Json.Decode.string)
  in
    Json.Decode.oneOf [ decodeSave, decodeFocus ]


encodeOutgoingNews : OutgoingNews -> Json.Encode.Value
encodeOutgoingNews og =
  case og of
    Save informativeText ->
      Json.Encode.object
        [ ( "save", encodeInformativeText <| informativeText )
        ]

    Focus elementName ->
      Json.Encode.object
        [ ( "focus", Json.Encode.string elementName ) ]


encodeNews : News Action OutgoingNews -> Json.Encode.Value
encodeNews og =
  case og of
    ServerSays wut ->
      Json.Encode.object
        [ ( "serverSays", encodeOutgoingNews <| wut )
        ]

    _ ->
      Json.Encode.string "This is not OK"


encodeInformativeText : InformativeText -> Json.Encode.Value
encodeInformativeText record =
  Json.Encode.object
    [ ( "text", Json.Encode.string <| record.text )
    , ( "position", encodePosition <| record.position )
    ]


encodePosition : PositionInDrawing -> Json.Encode.Value
encodePosition p =
  Json.Encode.object
    [ ( "x", Json.Encode.int <| p.x )
    , ( "y", Json.Encode.int <| p.y )
    , ( "naturalZoom", Json.Encode.int <| p.naturalZoom )
    ]


tuple2list ( a, b ) =
  [ a, b ]
