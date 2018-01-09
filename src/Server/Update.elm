port module Server.Update exposing (..)

-- import Common.World.Tile as Tile exposing (Item)
-- import Common.Point exposing (Point(Point))

import Common.Players.Main as Players
import Common.Players.Message as Message exposing (Action(..), Message)
import Common.World.Main as World exposing (World)
import Common.World.TileSet as TileSet exposing (BombInfo(BombInfo), Item)
import Process exposing (Id)
import Server.Model exposing (Model, UntilStart(Seconds, WaitForOpponent))
import Server.Update.NoLevel as NoLevel
import Task
import Time exposing (Time)


-- import Common.Players.Model exposing (updatePlayer)


port broadcast : String -> Cmd msg


port requestServer : Int -> Cmd msg


type Msg
    = PlayerAction Message
    | CountDown Int
    | BombExplosion Item
    | RemoveItem Item
    | NoLevel NoLevel.Msg


countDown : Int -> Cmd Msg
countDown t =
    if t >= 0 then
        Process.sleep (1 * Time.second) |> Task.perform (\_ -> CountDown t)
    else
        Cmd.none


playersUpdate : Message -> World -> World
playersUpdate msg world =
    -- TODO update functions to use it witout flip
    World.players world
        |> flip Players.updatePlayers msg
        |> flip World.setPlayers world


update : Msg -> Model -> ( Model, Cmd Msg )
update income model =
    let
        defaultUpdate msg world =
            ( { model
                | world = playersUpdate msg world |> Just
              }
            , Cmd.none
            )

        collision msg world =
            if TileSet.collision (World.tiles world) (Players.newPosition (World.players world) msg) /= Nothing then
                ( model, Cmd.none )
            else
                defaultUpdate msg world

        placeBomb message world =
            let
                players =
                    World.players world

                ref =
                    Message.ref message

                player =
                    Players.playerByMessage message players

                maybePlayer =
                    Players.decreaseBombCount player

                result =
                    maybePlayer
                        |> Maybe.map resultReturner
                        |> Maybe.withDefault ( model, Cmd.none )

                resultReturner gotPlayer =
                    let
                        tiles =
                            World.tiles world

                        speed =
                            Players.bombsTime player

                        bomb =
                            TileSet.bomb
                                (BombInfo
                                    { point = Players.possition player
                                    , speed = speed
                                    , size = Players.bombsSize player
                                    , owner = ref
                                    }
                                )

                        tilesWithNewBomb =
                            TileSet.add [ bomb ] tiles

                        newPlayers =
                            Players.set gotPlayer players

                        newWorld =
                            World.setPlayers newPlayers world
                                |> World.setTiles tilesWithNewBomb
                    in
                    ( { model
                        | world = Just newWorld
                      }
                    , Process.sleep (speed * Time.second) |> Task.perform (\_ -> BombExplosion bomb)
                    )
            in
            result
    in
    case ( income, model.world ) of
        ( NoLevel msg, Nothing ) ->
            let
                world =
                    NoLevel.update msg model.rooms

                cmd =
                    world
                        |> Maybe.map (requestServer << Players.count << World.players)
                        |> Maybe.withDefault Cmd.none
            in
            ( { model | world = world }, cmd )

        ( CountDown t, Just world ) ->
            ( { model | untilStart = Seconds t }, countDown (t - 1) )

        ( RemoveItem item, Just world ) ->
            let
                newTiles =
                    World.tiles world
                        |> TileSet.remove [ item ]

                newWorld =
                    world
                        |> World.setTiles newTiles
            in
            { model
                | world = Just newWorld
            }
                ! [ Cmd.none ]

        ( BombExplosion bomb, Just world ) ->
            let
                players =
                    World.players world

                tiles =
                    World.tiles world

                ( addItems, removeItems, dalayItemsToRemove, deadPlayers, bombsReturns ) =
                    TileSet.explosion bomb (Players.livePlayersDict players) tiles

                -- TODO make me more nice
                playersWithBombsReturned =
                    bombsReturns
                        |> List.foldl
                            (\x xs ->
                                Players.playerByRef x xs
                                    |> Players.increaseBombCount
                                    |> flip Players.set xs
                            )
                            players

                playersWithDeath =
                    deadPlayers
                        |> List.map (flip Players.playerByRef playersWithBombsReturned >> Players.die)
                        |> List.foldl Players.set playersWithBombsReturned

                newTiles =
                    tiles
                        |> TileSet.remove removeItems
                        |> TileSet.add addItems

                newWorld =
                    world
                        |> World.setPlayers playersWithDeath
                        |> World.setTiles newTiles

                cmds =
                    dalayItemsToRemove
                        |> List.map (\( t, item ) -> Process.sleep (t * Time.second) |> Task.perform (\_ -> RemoveItem item))
            in
            { model
                | world = Just newWorld
            }
                ! cmds

        ( PlayerAction msg, Just world ) ->
            case ( Message.action msg, model.untilStart ) of
                ( Message.Connected, WaitForOpponent ) ->
                    ( { model | world = playersUpdate msg world |> Just }, countDown model.waitTime )

                ( Message.Move _, Seconds 0 ) ->
                    collision msg world

                ( Message.Bomb, _ ) ->
                    placeBomb msg world

                _ ->
                    ( { model
                        | world = playersUpdate msg world |> Just
                      }
                    , Cmd.none
                    )

        _ ->
            ( model, Cmd.none )
