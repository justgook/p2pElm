module NewServer.Main exposing (..)

-- import NewServer.Port as Port

import NewServer.Subscriptions exposing (subscriptions)
import NewServer.Update exposing (Model, Msg, model, update)
import Platform exposing (programWithFlags)
import Shared.Port as Port


-- main : Program Never Model Msg


type alias Flags =
    { waitTime : Int
    , fps : Int
    }


flagsParser : Model -> ( Model, Cmd msg )
flagsParser flags =
    ( { model | waitTime = flags.waitTime, fps = flags.fps }, Port.serverReady () )


main : Program Model Model Msg
main =
    programWithFlags
        { init = flagsParser
        , update = update
        , subscriptions = subscriptions
        }
