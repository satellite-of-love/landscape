module NewsInjector (..) where

import Action exposing (News)


type alias NewsInjectorPane =
  { isAThing : Bool
  , contents : String
  , pretendWeJustReceived : List News
  }


init =
  { isAThing = False
  , contents = ""
  , pretendWeJustReceived = []
  }
