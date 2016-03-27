module Messages (..) where


type Message
  = Chunder String
  | Notice String
  | Save String
