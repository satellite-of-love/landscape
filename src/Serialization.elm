module Serialization (..) where

import Json.Encode
import Json.Decode exposing ((:=))
import Json.Decode.Extra exposing ((|:))
import Landscape exposing (InformativeText)
import Action exposing (News(ServerSays), Action, OutgoingNews(..))


decodeNews : Json.Decode.Decoder (News Action OutgoingNews)
decodeNews =
  Json.Decode.succeed ServerSays
    |: ("serverSays" := decodeServerSays)


decodeInformativeText : Json.Decode.Decoder InformativeText
decodeInformativeText =
  Json.Decode.succeed InformativeText
    |: ("text" := Json.Decode.string)
    |: ("position" := Json.Decode.tuple2 (,) Json.Decode.int Json.Decode.int)


decodeServerSays : Json.Decode.Decoder OutgoingNews
decodeServerSays =
  Json.Decode.succeed Save
    |: ("save" := decodeInformativeText)


encodeOutgoingNews : OutgoingNews -> Json.Encode.Value
encodeOutgoingNews og =
  case og of
    Save informativeText ->
      Json.Encode.object
        [ ( "save", encodeInformativeText <| informativeText )
        ]


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
    , ( "position", Json.Encode.list <| List.map Json.Encode.int <| tuple2list <| record.position )
    ]


tuple2list ( a, b ) =
  [ a, b ]
