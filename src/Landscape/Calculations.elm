module Landscape.Calculations (..) where

import Landscape exposing (ZoomLevel, LandscapeCenter, PositionInDrawing)


----
-- React to zoom request
----


findNewPlace : ZoomLevel -> ZoomLevel -> LandscapeCenter -> ( Int, Int ) -> ( ZoomLevel, LandscapeCenter )
findNewPlace howMuchToZoomIn currentZ currentCenter ( xClick, yClick ) =
  let
    divideByZoom a =
      round ((toFloat a) / (toFloat currentZ))

    ( xCurrentCenter, yCurrentCenter ) =
      currentCenter

    newX =
      (divideByZoom xClick) + (xCurrentCenter - (divideByZoom 35))

    newY =
      (divideByZoom yClick) + (yCurrentCenter - (divideByZoom 50))
  in
    ( currentZ + howMuchToZoomIn, ( newX, newY ) )



-----
-- Landscape background
-----


transform : ZoomLevel -> LandscapeCenter -> ( String, String )
transform z center =
  let
    translate =
      translateFunction z center

    scale =
      "scale(" ++ (toString z) ++ ")"
  in
    ( "transform", scale ++ " " ++ translate )


translateFunction : ZoomLevel -> LandscapeCenter -> String
translateFunction zoomLevel ( xCenter, yCenter ) =
  let
    xMove =
      35 - xCenter

    yMove =
      50 - yCenter
  in
    "translate(" ++ (toString xMove) ++ "vw," ++ (toString yMove) ++ "vh)"



-----
-- Each text input
-----


type alias CssTransformation =
  { scale : Int
  , translateX : Int
  , translateY : Int
  }


calculateTransformation : ZoomLevel -> LandscapeCenter -> PositionInDrawing -> CssTransformation
calculateTransformation zoom ( xCenter, yCenter ) ( xText, yText ) =
  { scale = zoom
  , translateX = xText - xCenter
  , translateY = yText - yCenter
  }


toStyle : CssTransformation -> String
toStyle spec =
  let
    scale =
      "scale(" ++ (toString spec.scale) ++ ")"

    translate =
      "translate(" ++ (toString spec.translateX) ++ "vw," ++ (toString spec.translateY) ++ "vh)"
  in
    scale ++ " " ++ translate


transformText : ZoomLevel -> LandscapeCenter -> PositionInDrawing -> ( String, String )
transformText zoom center pos =
  ( "transform", toStyle <| (calculateTransformation zoom center pos) )
