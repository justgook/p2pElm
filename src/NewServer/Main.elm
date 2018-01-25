module NewServer.Main exposing (..)

-- import NewServer.Port as Port

import NewServer.Port as Port
import NewServer.Subscriptions exposing (subscriptions)
import NewServer.Update exposing (Model, Msg, model, update)
import Platform exposing (programWithFlags)


-- main : Program Never Model Msg


type alias Flags =
    { waitTime : Int
    , fps : Int
    }


flagsParser : Flags -> ( Model, Cmd msg )
flagsParser flags =
    ( { model | waitTime = flags.waitTime, fps = flags.fps }, Port.server_ready () )


main : Program Flags Model Msg
main =
    programWithFlags
        { init = flagsParser
        , update = update
        , subscriptions = subscriptions
        }
