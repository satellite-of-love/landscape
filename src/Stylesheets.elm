module Stylesheets (..) where

import Css.File exposing (CssFileStructure, toFileStructure)
import LandscapeCss as Landscape


port files : CssFileStructure
port files =
  toFileStructure
    [ ( "styles.css", compile Landscape.css ) ]
