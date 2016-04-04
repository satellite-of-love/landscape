module Landscape (..) where


type alias ZoomLevel =
  Int


type alias LandscapeCenter =
  ( Int, Int )


type alias PositionInDrawing =
  ( Int, Int )


type alias InformativeText =
  { text : String
  , position : PositionInDrawing
  , naturalZoom : ZoomLevel
  }
