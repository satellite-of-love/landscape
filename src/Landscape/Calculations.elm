module Landscape.Calculations (..) where

import Landscape exposing (ZoomLevel, LandscapeCenter, PositionInDrawing, WhereAmI)
import Base exposing (PositionOnScreen)


----
-- React to zoom request
----


findNewPlace : ZoomLevel -> WhereAmI -> PositionOnScreen -> WhereAmI
findNewPlace howMuchToZoomIn current click =
  let
    recenter =
      whereIsThis current click
  in
    { x = recenter.x
    , y = recenter.y
    , zoom = current.zoom + howMuchToZoomIn
    }


whereIsThis : WhereAmI -> PositionOnScreen -> PositionInDrawing
whereIsThis current ( xClick, yClick ) =
  let
    divideByZoom a =
      round ((toFloat a) / current.zoom)

    newX =
      (divideByZoom xClick) + (current.x - (divideByZoom 35))

    newY =
      (divideByZoom yClick) + (current.y - (divideByZoom 50))
  in
    { x = newX, y = newY, naturalZoom = current.zoom }



-----
-- Landscape background
-----


transform : WhereAmI -> ( String, String )
transform pos =
  let
    translate =
      translateFunction pos

    scale =
      "scale(" ++ (toString pos.zoom) ++ ")"
  in
    ( "transform", scale ++ " " ++ translate )


translateFunction : WhereAmI -> String
translateFunction pos =
  let
    xMove =
      35 - pos.x

    yMove =
      50 - pos.y
  in
    "translate(" ++ (toString xMove) ++ "vw," ++ (toString yMove) ++ "vh)"



-----
-- Each text input
-----


type alias CssTransformation =
  { scale : Float
  , translateX : Int
  , translateY : Int
  }


calculateTransformation : WhereAmI -> PositionInDrawing -> CssTransformation
calculateTransformation whereAmI positionOfThing =
  let
    scale =
      whereAmI.zoom

    divideByScale i =
      i
  in
    { scale = scale
    , translateX = divideByScale (positionOfThing.x - whereAmI.x)
    , translateY = divideByScale (positionOfThing.y - whereAmI.y)
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


transformText : WhereAmI -> PositionInDrawing -> ( String, String )
transformText whereAmI textPos =
  ( "transform", toStyle <| (calculateTransformation whereAmI textPos) )


anchorX =
  35


anchorY =
  50



-- This exists for testing the CssTransformation calculations.
-- Hopefully it corresponds to what the browser does.


resultingPositionOnScreen : CssTransformation -> PositionOnScreen
resultingPositionOnScreen spec =
  ( anchorX + (round ((toFloat spec.translateX) * spec.scale))
  , anchorY + (round ((toFloat spec.translateY) * spec.scale))
  )
