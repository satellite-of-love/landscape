module Messages (..) where

import Set exposing (Set)

type MessageImportance = Chunder | Notice | Save

type alias Message = { say: String, importance: MessageImportance }


type alias MessageVisibility =
  List MessageImportance


allVisible : MessageVisibility
allVisible =
  [ Chunder, Notice, Save ]
