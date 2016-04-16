module Landscape (..) where


type alias ZoomLevel =
  Int


type alias XFromFarLeft =
  Int


type alias YFromVeryTop =
  Int


type alias PositionInDrawing =
  { x : XFromFarLeft
  , y : YFromVeryTop
  , naturalZoom : ZoomLevel
  }


type alias WhereAmI =
  { x : XFromFarLeft
  , y : YFromVeryTop
  , zoom : ZoomLevel
  }


initialPosition : WhereAmI
initialPosition =
  { x = 35, y = 50, zoom = 1 }


type alias LandscapeCenter =
  ( XFromFarLeft, YFromVeryTop )


type alias InformativeText =
  { text : String
  , position : PositionInDrawing
  }
