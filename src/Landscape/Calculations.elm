module Landscape.Calculations (transformText, transform, translateFunction, findNewPlace) where

import Landscape exposing (ZoomLevel, LandscapeCenter, PositionInDrawing)


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


translateText : ZoomLevel -> LandscapeCenter -> PositionInDrawing -> String
translateText zoom ( xCenter, yCenter ) ( xText, yText ) =
  let
    xMove =
      (xText - xCenter)

    yMove =
      (yText - yCenter)
  in
    "translate(" ++ (toString xMove) ++ "vw," ++ (toString yMove) ++ "vh)"


transformText : ZoomLevel -> LandscapeCenter -> PositionInDrawing -> ( String, String )
transformText zoom center pos =
  let
    translate =
      translateText zoom center pos

    scale =
      "scale(" ++ (toString zoom) ++ ")"
  in
    ( "transform", scale ++ " " ++ translate )


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
