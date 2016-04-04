module Landscape.Calculations (transform, translateFunction, findNewPlace) where


type alias ZoomLevel =
  Int


type alias LandscapeCenter =
  ( Int, Int )


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
