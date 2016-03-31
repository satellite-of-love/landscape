module Landscape (..) where


type alias Bearings =
  ( Int, Int )


type alias InformativeText =
  { text : String
  , position : Bearings
  }
