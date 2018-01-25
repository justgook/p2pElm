port module NewServer.Update exposing (Model, Msg(..), model, update)

import Common.Players.Message as PlayersMessage exposing (Action(..))
import Game.Entities as Entities exposing (Entities(Entities), Entity(..), PlayerStatus(..))
import NewServer.Port as Port
import Shared.Protocol as Protocol exposing (Message(..))


-- import Shared.Port as Port


type alias Model =
    { entities : Entities
    , fps : Int
    , waitTime : Int
    , players : List Entities.Entity
    }


model : Model
model =
    { waitTime = 0
    , fps = 0
    , entities = Entities.empty
    , players = []
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
                (PlayersMessage.PlayerRef { index }) =
                    PlayersMessage.ref m

                newPlayers =
                    if PlayersMessage.action m == Connected then
                        get index model.players
                            |> Maybe.map playerOnline
                            |> Maybe.map (flip (replace index) model.players)
                            |> Maybe.withDefault model.players
                    else
                        model.players

                (Entities entities) =
                    model.entities

                _ =
                    Debug.log "222PlayerAction On Server" <| 3
            in
            -- model ! (cmd :: Entities.map sendAdd model.entities)
            model ! Entities.map sendAdd (Entities (entities ++ List.filter isOnline newPlayers))

        Start room ->
            let
                ( Entities players, entities ) =
                    Entities.fromString room
                        |> Entities.partition isPlayer
            in
            { model | entities = entities, players = players } ! [ Cmd.none ]


sendAdd : Entity -> Cmd msg
sendAdd =
    Port.server_outcome << Protocol.serialize << entity2addMsg


get : Int -> List a -> Maybe a
get n xs =
    List.head (List.drop n xs)


replace : Int -> a -> List a -> List a
replace index item xs =
    List.take index xs
        ++ [ item ]
        ++ List.drop (index + 1) xs


entity2addMsg : Entities.Entity -> Protocol.Message
entity2addMsg e =
    Protocol.Entity (Protocol.Add e)


isOnline : Entity -> Bool
isOnline e =
    case e of
        Player { status } ->
            if status == PlayerOnline then
                True
            else
                False

        _ ->
            False


isPlayer : Entity -> Bool
isPlayer e =
    case e of
        Player _ ->
            True

        _ ->
            False


playerOnline : Entity -> Entity
playerOnline e =
    case e of
        Player data ->
            Player { data | status = PlayerOnline }

        _ ->
            e
