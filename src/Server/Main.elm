module Main exposing (..)

import Common.World.Main exposing (decode)
import Html
import Server.Message exposing (Msg)
import Server.Model exposing (Model, init, model)
import Server.Subscriptions exposing (subscriptions)
import Server.Update exposing (update)
import Server.View exposing (view)


type alias Flags =
    { room : String
    , waitTime : Int
    , fps : Int
    }


flagsParser : Flags -> ( Model, Cmd Msg )
flagsParser flags =
    ( { model | world = decode flags.room, waitTime = flags.waitTime, fps = flags.fps }, Cmd.none )


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = flagsParser
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
