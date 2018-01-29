port module NewServer.Update exposing (Model, Msg(..), PlayerSlot(..), Players, model, update)

import Common.Players.Message as PlayersMessage exposing (Action(..), Direction(..))
import Common.Point exposing (Point(Point))
import Dict exposing (Dict)
import Game.Entities as Entities exposing (Entities(Entities), Entity(..), PlayerStatus(..))
import NewServer.Port as Port
import Process
import Shared.Protocol as Protocol exposing (Message(..))
import Task
import Time


type PlayerSlot
    = SlotTaken Entities.Id
    | SlotFree Entity


type alias Players =
    Dict Int PlayerSlot


type alias Model =
    { entities : Entities
    , fps : Int
    , waitTime : Int
    , players : Players
    , lastId : Entities.Id
    }


model : Model
model =
    { waitTime = 0
    , fps = 0
    , entities = Entities.empty
    , players = Dict.empty
    , lastId = 0
    }


type Msg
    = PlayerConnects Int Entity
    | PlayerMove Direction Entity
    | PlayerBomb Entity
    | PlayerNotAllowedAction
    | BombExplode Entities.Id
    | Start String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PlayerNotAllowedAction ->
            let
                _ =
                    Debug.log "PlayerNotAllowedAction" msg
            in
            ( model, Cmd.none )

        BombExplode bombId ->
            let
                ( explPoints, items2remove, deadPlayers ) =
                    Entities.explode bombId model.entities

                playersBombsReturned =
                    explosinResult items2remove model.entities

                explosionEntity =
                    Explosion bombId explPoints

                entities =
                    --Entities.add [ newEntities ] No point of store explosion on server
                    model.entities
                        |> Entities.remove items2remove
                        |> Entities.add playersBombsReturned
            in
            { model | entities = entities }
                ! (List.map sendAddOrUpdate (explosionEntity :: playersBombsReturned)
                    ++ List.map sendRemove items2remove
                  )

        PlayerConnects connId entity ->
            let
                newEntities =
                    Entities.add [ entity ] model.entities

                newPlayers =
                    Dict.insert connId (SlotTaken <| Entities.id entity) model.players
            in
            { model
                | entities = newEntities
                , players = newPlayers
            }
                ! (newConnection connId
                    :: Entities.map sendAddOrUpdate newEntities
                  )

        PlayerMove dir playerEntity ->
            let
                newPos =
                    movePoint (Entities.position playerEntity) dir
            in
            case Entities.collision newPos model.entities of
                Nothing ->
                    let
                        entity =
                            Entities.setPosition newPos playerEntity
                    in
                    { model | entities = Entities.update [ entity ] model.entities } ! [ sendAddOrUpdate entity ]

                Just item ->
                    let
                        _ =
                            Debug.log "Player colides with" item
                    in
                    ( model, Cmd.none )

        PlayerBomb entity ->
            let
                _ =
                    Debug.log "WEEE!!" model.lastId

                ( newEntities, lastId, cmd ) =
                    placeBomb model.lastId entity
            in
            { model
                | entities = Entities.update newEntities model.entities
                , lastId = lastId
            }
                ! (cmd :: List.map sendAddOrUpdate newEntities)

        Start room ->
            let
                ( ( players, entities ), lastId ) =
                    Entities.fromString room
                        |> Tuple.mapFirst (Entities.partition isPlayer)
                        |> ((List.indexedMap (\i e -> ( i, SlotFree e )) >> Dict.fromList)
                                |> Tuple.mapFirst
                                |> Tuple.mapFirst
                           )
            in
            { model
                | entities = entities
                , lastId = lastId
                , players = players
            }
                ! [ Cmd.none ]


explosinResult : List Entities.Id -> Entities -> List Entity
explosinResult a b =
    let
        helper items2remove entities acc =
            case items2remove of
                x :: xs ->
                    case Entities.get x entities of
                        Just (Entities.Bomb n { size, author, point }) ->
                            case ( Dict.get author acc, Entities.get author entities ) of
                                ( Just (Entities.Player n data), _ ) ->
                                    Dict.insert n (Entities.Player n { data | bombsLeft = data.bombsLeft + 1 }) acc
                                        |> helper xs entities

                                ( Nothing, Just (Entities.Player n data) ) ->
                                    Dict.insert n (Entities.Player n { data | bombsLeft = data.bombsLeft + 1 }) acc
                                        |> helper xs entities

                                _ ->
                                    helper xs entities acc

                        e ->
                            helper xs entities acc

                [] ->
                    acc
    in
    helper a b Dict.empty
        |> Dict.values


placeBomb : Entities.Id -> Entity -> ( List Entity, Entities.Id, Cmd Msg )
placeBomb lastId entity =
    case entity of
        Player n ({ point, bombsLeft, explosionTime, explosionSize } as data) ->
            if bombsLeft - 1 >= 0 then
                let
                    newId =
                        lastId + 1
                in
                ( [ Entities.Bomb newId { size = explosionSize, author = n, point = point }
                  , Player n { data | bombsLeft = bombsLeft - 1 }
                  ]
                , newId
                , Process.sleep (explosionTime * Time.second) |> Task.perform (\_ -> BombExplode newId)
                )
            else
                ( [ entity ], lastId, Cmd.none )

        _ ->
            ( [ entity ], lastId, Cmd.none )


movePoint : Point -> Direction -> Point
movePoint (Point x y) dir =
    case dir of
        North ->
            Point x (y - 1)

        East ->
            Point (x + 1) y

        South ->
            Point x (y + 1)

        West ->
            Point (x - 1) y


newConnection : Int -> Cmd msg
newConnection =
    Port.server_outcome << Protocol.serialize << NewConnection


sendAddOrUpdate : Entity -> Cmd msg
sendAddOrUpdate =
    Port.server_outcome << Protocol.serialize << entity2addMsg


sendRemove : Entities.Id -> Cmd msg
sendRemove =
    Port.server_outcome << Protocol.serialize << entity2addMsgRemove


entity2addMsgRemove : Entities.Id -> Message
entity2addMsgRemove e =
    Protocol.Entity (Protocol.Remove e)


entity2addMsg : Entity -> Protocol.Message
entity2addMsg e =
    Protocol.Entity (Protocol.Add e)


isOnline : Entity -> Bool
isOnline e =
    case e of
        Player _ { status } ->
            if status == PlayerOnline then
                True
            else
                False

        _ ->
            False


isPlayer : a -> Entity -> Bool
isPlayer _ e =
    case e of
        Player _ _ ->
            True

        _ ->
            False
