module Server.Model exposing (..)

import Common.World.Main as World exposing (World)


-- import Server.Update exposing (Msg)


type UntilStart
    = Seconds Int
    | WaitForOpponent


type alias Model =
    { world : Maybe World
    , untilStart : UntilStart
    , waitTime : Int
    , rooms : List String
    , fps : Int
    }



-- init : ( Model, Cmd Msg )
-- init =
--     ( model, Cmd.none )


model : Model
model =
    { world = Nothing
    , rooms = []
    , untilStart = WaitForOpponent
    , waitTime = 0
    , fps = 0
    }
