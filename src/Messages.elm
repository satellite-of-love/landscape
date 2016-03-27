module Messages (..) where

import Set exposing (Set)
import LandscapeCss


type alias MessageImportance =
  { name : String, cssClass : LandscapeCss.CssClass }


chunder : MessageImportance
chunder =
  { name = "Chunder", cssClass = LandscapeCss.Chunder }


notice : MessageImportance
notice =
  { name = "Notice", cssClass = LandscapeCss.Notice }


save : MessageImportance
save =
  { name = "Save", cssClass = LandscapeCss.Save }


importances =
  [ chunder
  , notice
  , save
  ]


type alias Message =
  { importance : MessageImportance, say : String }


type alias MessageImportanceShouldBeComparable =
  String


type alias MessageVisibility =
  Set MessageImportanceShouldBeComparable


isVisible : MessageVisibility -> MessageImportance -> Bool
isVisible visibility importance =
  Set.member (makeComparable importance) visibility


allVisible : MessageVisibility
allVisible =
  importances |> List.map makeComparable |> Set.fromList


removeVisibility : MessageImportance -> MessageVisibility -> MessageVisibility
removeVisibility =
  Set.remove << makeComparable


addVisibility : MessageImportance -> MessageVisibility -> MessageVisibility
addVisibility =
  Set.insert << makeComparable


makeComparable : MessageImportance -> MessageImportanceShouldBeComparable
makeComparable =
  .name
