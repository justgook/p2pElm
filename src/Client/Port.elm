port module Client.Port exposing (..)

import Client.GUI.View.GameList as GameList exposing (Data)
import Shared.Protocol exposing (Serialized)


port client_outcome : Int -> Cmd msg


port client_income : (Serialized -> msg) -> Sub msg


port client_join : String -> Cmd msg


port client_create : String -> Cmd msg


port client_serverListRequest : () -> Cmd msg


port client_serverListResponse : (GameList.Data -> msg) -> Sub msg
