port module NewServer.Port exposing (..)

import Shared.Protocol exposing (Serialized)


port server_ready : () -> Cmd msg


port server_income : (( Int, Int, Int ) -> msg) -> Sub msg


port server_outcome : Serialized -> Cmd msg


port server_start : (String -> msg) -> Sub msg
