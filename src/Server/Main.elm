module Main exposing (..)

import Common.World.Main exposing (decode)
import Html
import Server.Model exposing (Model, model)
import Server.Subscriptions exposing (subscriptions)
import Server.Update exposing (Msg, update)
import Server.View exposing (view)


type alias Flags =
    { rooms : List String
    , waitTime : Int
    , fps : Int
    }


flagsParser : Flags -> ( Model, Cmd Msg )
flagsParser flags =
    ( { model | rooms = flags.rooms, waitTime = flags.waitTime, fps = flags.fps }, Cmd.none )


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = flagsParser
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
