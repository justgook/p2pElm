module Shared.Protocol
    exposing
        ( EntityAction(..)
        , Message(..)
        , Serialized
        , deserialize
        , serialize
        )

import Common.Point exposing (Point(Point))
import Game.Entities as GEntities


type Message
    = Entity EntityAction
    | ServerStatus
    | NewConnection Int
    | Error Serialized


type EntityAction
    = Add GEntities.Entity
    | Remove GEntities.Id



-- https://codereview.stackexchange.com/questions/3569/pack-and-unpack-bytes-to-strings


type alias Serialized =
    List String


serialize : Message -> Serialized
serialize msg =
    -- var realArray = Array.prototype.slice.call(uint8array);
    -- app.ports.receiveImage.send(realArray);
    case msg of
        Entity (Add entity) ->
            [ "add" ] ++ fromEntity entity

        Entity (Remove id) ->
            [ "remove" ] ++ [ toString id ]

        ServerStatus ->
            [ "a" ]

        NewConnection connId ->
            [ "connection", toString connId ]

        Error m ->
            let
                _ =
                    Debug.log "Protocol serialize got unknown Msg" m
            in
            [ "error" ]


deserialize : Serialized -> Message
deserialize data =
    case data of
        "add" :: "1" :: n :: x :: y :: isDead :: speed :: bombsLeft :: explosionTime :: explosionSize :: [] ->
            add <|
                GEntities.Player (str2int n)
                    { isDead = isDead == "1"
                    , point = point x y
                    , speed = str2int speed
                    , bombsLeft = str2int bombsLeft
                    , explosionTime = str2float explosionTime
                    , explosionSize = str2int explosionSize
                    }

        "add" :: "2" :: n :: x :: y :: [] ->
            add <| GEntities.Box (str2int n) (point x y)

        "add" :: "3" :: n :: x :: y :: [] ->
            add <| GEntities.Wall (str2int n) (point x y)

        "add" :: "4" :: n :: x :: y :: [] ->
            -- For render we don't care about size / author
            add <| GEntities.Bomb (str2int n) { size = 0, author = 0, point = point x y }

        "add" :: "5" :: n :: xs ->
            add <| GEntities.Explosion (str2int n) <| dualFold (\x y -> Point (str2int x) (str2int y)) xs []

        "remove" :: id :: [] ->
            remove (str2int id)

        "connection" :: connId :: [] ->
            NewConnection <| str2int connId

        msg ->
            Error msg


fromEntity : GEntities.Entity -> List String
fromEntity e =
    case e of
        GEntities.Player n { isDead, point, speed, bombsLeft, explosionTime, explosionSize } ->
            let
                (Point x y) =
                    point
            in
            [ "1"
            , toString n
            , toString x
            , toString y
            , if isDead then
                "1"
              else
                "0"
            , toString speed
            , toString bombsLeft
            , toString explosionTime
            , toString explosionSize
            ]

        GEntities.Box n (Point x y) ->
            [ "2", toString n, toString x, toString y ]

        GEntities.Wall n (Point x y) ->
            [ "3", toString n, toString x, toString y ]

        GEntities.Bomb n { size, author, point } ->
            let
                (Point x y) =
                    point
            in
            [ "4", toString n, toString x, toString y ]

        GEntities.Explosion n points ->
            [ "5", toString n ] ++ List.concatMap (\(Point x y) -> [ toString x, toString y ]) points


dualFold : (a -> a -> b) -> List a -> List b -> List b
dualFold f l acc =
    case l of
        x :: y :: xs ->
            dualFold f xs (acc ++ [ f x y ])

        _ ->
            acc


str2int : String -> Int
str2int =
    Result.withDefault 0 << String.toInt


str2float : String -> Float
str2float =
    Result.withDefault 0 << String.toFloat


point : String -> String -> Point
point x y =
    Point (str2int x) (str2int y)


add : GEntities.Entity -> Message
add =
    Entity
        << Add


remove : GEntities.Id -> Message
remove =
    Entity
        << Remove
