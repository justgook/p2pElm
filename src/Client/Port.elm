port module Client.Port exposing (..)

import Client.GUI.View.GameList as GameList exposing (Data)
import Shared.Protocol exposing (Serialized)


--Client Stuff


port clientAction : Int -> Cmd msg



--TODO find better naming


port levelUpdate : (Serialized -> msg) -> Sub msg


port join : String -> Cmd msg


port create : String -> Cmd msg


port serverListRequest : () -> Cmd msg


port serverListResponse : (GameList.Data -> msg) -> Sub msg
