port module NewServer.Subscriptions exposing (subscriptions)

-- import Common.World.Main exposing (players)
-- https://gist.github.com/r-k-b/e589b02d68cab07af63347507c8d0a2d
-- Task.perform never TimeSuccess Time.now
-- Port.toServerRestart

import Common.Players.Message as PlayersMessage exposing (Action(..), incomeToMessage)
import Dict
import Game.Entities as Entities exposing (Entities)
import NewServer.Port as Port
import NewServer.Update as Server exposing (Model, Msg(..), PlayerSlot(..), Players)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ incomeToMessage >> playerAction model.players model.entities |> Port.server_income
        , Port.server_start Server.Start
        ]


playerAction : Players -> Entities -> PlayersMessage.Message -> Msg
playerAction players entities msg =
    let
        ref =
            PlayersMessage.ref msg

        action =
            PlayersMessage.action msg
    in
    case Dict.get ref players of
        Just (SlotTaken entityId) ->
            case Entities.get entityId entities of
                Just playerEntity ->
                    case action of
                        Move dir ->
                            PlayerMove dir playerEntity

                        Bomb ->
                            PlayerBomb playerEntity

                        _ ->
                            PlayerNotAllowedAction

                Nothing ->
                    PlayerNotAllowedAction

        Just (SlotFree entity) ->
            case action of
                Connected ->
                    PlayerConnects ref entity

                _ ->
                    PlayerNotAllowedAction

        --  case Entities.get entityId model.entities of
        Nothing ->
            PlayerNotAllowedAction



-- type Action
--     = Connected
--     | Disconnected
--     | Move Direction
--     | Bomb
--     | Error
-- case action of
--     PlayersMessage.Move dir ->
--     _ ->
--         Cmd.none
