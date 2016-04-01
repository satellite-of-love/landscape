module Serialization (..) where

import Json.Encode
import Json.Decode exposing ((:=))
import Json.Decode.Extra exposing ((|:))
import Landscape exposing (InformativeText)


type alias News =
  { ack : NewsAck
  }


type alias NewsAck =
  { save : InformativeText
  }


decodeNews : Json.Decode.Decoder News
decodeNews =
  Json.Decode.succeed News
    |: ("ack" := decodeNewsAck)


decodeInformativeText : Json.Decode.Decoder InformativeText
decodeInformativeText =
  Json.Decode.succeed InformativeText
    |: ("text" := Json.Decode.string)
    |: ("position" := Json.Decode.tuple2 (,) Json.Decode.int Json.Decode.int)


decodeNewsAck : Json.Decode.Decoder NewsAck
decodeNewsAck =
  Json.Decode.succeed NewsAck
    |: ("save" := decodeInformativeText)


encodeNews : News -> Json.Encode.Value
encodeNews record =
  Json.Encode.object
    [ ( "ack", encodeNewsAck <| record.ack )
    ]


encodeInformativeText : InformativeText -> Json.Encode.Value
encodeInformativeText record =
  Json.Encode.object
    [ ( "text", Json.Encode.string <| record.text )
    , ( "position", Json.Encode.list <| List.map Json.Encode.int <| tuple2list <| record.position )
    ]


tuple2list ( a, b ) =
  [ a, b ]


encodeNewsAck : NewsAck -> Json.Encode.Value
encodeNewsAck record =
  Json.Encode.object
    [ ( "save", encodeInformativeText <| record.save )
    ]
