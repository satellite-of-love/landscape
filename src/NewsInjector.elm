module NewsInjector (..) where

import Action exposing (News, Action, OutgoingNews)


type alias NewsInjectorPane =
  { isAThing : Bool
  , contents : String
  , pretendWeJustReceived : List (News Action OutgoingNews)
  , error : Maybe String
  }


init =
  { isAThing = False
  , contents = ""
  , pretendWeJustReceived = []
  , error = Nothing
  }
