module LandscapeCss (css) where

import Css exposing (..)
import Css.Elements exposing (..)
import Css.Namespace exposing (namespace)
import CssInterface exposing (cssNamespace)


css =
  stylesheet
    [ aside
        [ backgroundColor (rgb 90 90 90)
        , boxSizing borderBox
        , padding (px -80)
        ]
    ]

--aside {
--  background-color: white;
--  margin: 0;
--  padding: 0;
--  left: 70%;
--  width: 30%;
--  height: 100%;
--  border: medium groove green;
--  position: absolute;
--  vertical-align: top;
--  overflow: scroll;
--}