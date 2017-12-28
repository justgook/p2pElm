port module Server.Update exposing (..)

import Common.Players.Main as Players exposing (Action)
import Common.World.Main as World
import Common.World.Tile as Tile
import Process exposing (Id)
import Server.Message exposing (Msg(..))
import Server.Model exposing (Model, UntilStart(Seconds, WaitForPlayers))
import Task
import Time exposing (Time)


-- import Common.Players.Model exposing (updatePlayer)


port broadcast : String -> Cmd msg


port requestServer : Int -> Cmd msg


countDown : Int -> Cmd Msg
countDown t =
    if t >= 0 then
        Process.sleep (1 * Time.second) |> Task.perform (\_ -> CountDown t)
    else
        Cmd.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ world } as model) =
    let
        defaultUpdate message =
            ( { model | world = World.withUpdatedPlayer world message }, Cmd.none )

        collision message =
            if World.collision world message then
                ( model, Cmd.none )
            else
                defaultUpdate message

        placeBomb message =
            let
                ref =
                    Players.playerRefByMessage message
            in
            case World.placeBomb world ref of
                Just { world, bomb, explosionIn } ->
                    ( { model
                        | world = world
                      }
                    , Process.sleep (explosionIn * Time.second) |> Task.perform (\_ -> BombExplosion bomb)
                    )

                Nothing ->
                    ( model, Cmd.none )
    in
    case msg of
        PlayerCount c ->
            ( { model | untilStart = WaitForPlayers }, requestServer c )

        CountDown t ->
            ( { model | untilStart = Seconds t }, countDown (t - 1) )

        BombExplosion bomb ->
            case Tile.bomb2info bomb of
                -- TODO make me cleaner
                Just info ->
                    { model | world = World.boom world info }
                        ! [ Cmd.none ]

                Nothing ->
                    ( model, Cmd.none )

        PlayerAction message ->
            case ( Players.action message, model.untilStart ) of
                ( Players.Connected, WaitForPlayers ) ->
                    ( { model | world = World.withUpdatedPlayer world message }, countDown model.waitTime )

                ( Players.Move _, Seconds 0 ) ->
                    collision message

                ( Players.Bomb, _ ) ->
                    placeBomb message

                _ ->
                    defaultUpdate message
