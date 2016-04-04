module Landscape.Calculations (translateFunction, findNewPlace) where


type alias ZoomLevel =
  Int


type alias LandscapeCenter =
  ( Int, Int )


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
    ( xCurrentCenter, yCurrentCenter ) =
      currentCenter

    newX =
      xClick + (xCurrentCenter - 35)

    newY =
      yClick + (yCurrentCenter - 50)
  in
    ( currentZ + howMuchToZoomIn, ( newX, newY ) )
