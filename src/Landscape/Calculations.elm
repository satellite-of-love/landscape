module Landscape.Calculations (..) where

import Landscape exposing (ZoomLevel, LandscapeCenter, PositionInDrawing, WhereAmI)
import Base exposing (PositionOnScreen)
import LandscapeCss
import Css exposing (vh, vw)


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


type alias GetOnTheScreenRightHere =
  { fromTop : Float
  , fromLeft : Float
  , scale : Float
  , translateX : Int
  , translateY : Int
  }


calculateTransformation : WhereAmI -> PositionInDrawing -> GetOnTheScreenRightHere
calculateTransformation whereAmI positionOfThing =
  let
    scale =
      whereAmI.zoom

    divideByScale i =
      i
  in
    { fromTop = anchorY
    , fromLeft = anchorX
    , scale = scale
    , translateX = divideByScale (positionOfThing.x - whereAmI.x)
    , translateY = divideByScale (positionOfThing.y - whereAmI.y)
    }


transformStyle : GetOnTheScreenRightHere -> String
transformStyle spec =
  let
    scale =
      "scale(" ++ (toString spec.scale) ++ ")"

    translate =
      "translate(" ++ (toString spec.translateX) ++ "vw," ++ (toString spec.translateY) ++ "vh)"
  in
    scale ++ " " ++ translate


positioningStyles : GetOnTheScreenRightHere -> List ( String, String )
positioningStyles spec =
  let
    absolutePositioning =
      (Css.asPairs (LandscapeCss.beAt (vh spec.fromTop) (vw spec.fromLeft)))
  in
    absolutePositioning ++ [ ( "transform", transformStyle spec ) ]


transformText : WhereAmI -> PositionInDrawing -> List ( String, String )
transformText whereAmI textPos =
  calculateTransformation whereAmI textPos |> positioningStyles


anchorX =
  35


anchorY =
  50



-- This exists for testing the CssTransformation calculations.
-- Hopefully it corresponds to what the browser does.


resultingPositionOnScreen : GetOnTheScreenRightHere -> PositionOnScreen
resultingPositionOnScreen spec =
  ( anchorX + (round ((toFloat spec.translateX) * spec.scale))
  , anchorY + (round ((toFloat spec.translateY) * spec.scale))
  )
