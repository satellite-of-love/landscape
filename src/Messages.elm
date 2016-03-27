module Messages (..) where

import Set exposing (Set)


type MessageImportance
  = Chunder
  | Notice
  | Save


importancesWithDescriptions =
  [ ( Chunder, "Chunder" )
  , ( Notice, "Notice" )
  , ( Save, "Save" )
  ]


type alias Message =
  { say : String, importance : MessageImportance }


type alias MessageImportanceShouldBeComparable =
  Int


type alias MessageVisibility =
  Set MessageImportanceShouldBeComparable


isVisible : MessageVisibility -> MessageImportance -> Bool
isVisible visibility importance =
  Set.member (makeComparable importance) visibility


allVisible : MessageVisibility
allVisible =
  [ Chunder, Notice, Save ] |> List.map makeComparable |> Set.fromList


removeVisibility : MessageImportance -> MessageVisibility -> MessageVisibility
removeVisibility =
  Set.remove << makeComparable


addVisibility : MessageImportance -> MessageVisibility -> MessageVisibility
addVisibility =
  Set.insert << makeComparable


makeComparable : MessageImportance -> MessageImportanceShouldBeComparable
makeComparable mi =
  case mi of
    Chunder ->
      0

    Notice ->
      1

    Save ->
      2
