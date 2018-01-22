port module NewServer.Update exposing (Model, Msg(..), model, update)

import Common.Players.Message as PlayersMessage exposing (Message)
import Game.Entities as Entities
import Shared.Port as Port
import Shared.Protocol as Protocol exposing (Message(..))


-- import Shared.Port as Port


type alias Model =
    { waitTime : Int
    , fps : Int
    }


model : Model
model =
    { waitTime = 0
    , fps = 0
    }


type Msg
    = Increment
    | Decrement
    | PlayerAction PlayersMessage.Message
    | Start String



-- http://blog.elmnarrativeengine.com/


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( model, Cmd.none )

        Decrement ->
            ( model, Cmd.none )

        PlayerAction m ->
            let
                _ =
                    Debug.log "222PlayerAction On Server" m
            in
            ( model, Cmd.none )

        Start room ->
            let
                entities =
                    Entities.fromString room
            in
            model ! Entities.map (Port.toClient << Protocol.serialize << entity2addMsg) entities


entity2addMsg : Entities.Entity -> Protocol.Message
entity2addMsg e =
    Protocol.Entity (Protocol.Add e)
