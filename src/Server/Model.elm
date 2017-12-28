module Server.Model exposing (..)

import Common.World.Main as World exposing (World)
import Server.Message exposing (Msg)


type UntilStart
    = Seconds Int
    | NotSet
    | WaitForPlayers


type alias Model =
    { world : World
    , untilStart : UntilStart
    , waitTime : Int
    , fps : Int
    }


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )


model : Model
model =
    { world = World.init
    , untilStart = NotSet
    , waitTime = 0
    , fps = 0
    }
