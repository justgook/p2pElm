module Server.Message exposing (..)

import Common.Players.Main exposing (Message)
import Common.World.Tile exposing (Item)


type Msg
    = PlayerAction Message
    | PlayerCount Int
    | CountDown Int
    | BombExplosion Item
