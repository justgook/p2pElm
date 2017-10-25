module Server.Message exposing (..)

-- import Keyboard exposing (KeyCode)
-- import Time exposing (Time)

-- type Action = Connected | Disconnected | Up | Right | Down | Left | Bomb | Error
-- type alias Index = Int

type Msg = PlayerAction (Int, Int)
