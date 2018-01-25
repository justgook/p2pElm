module Shared.Protocol
    exposing
        ( EntityAction(..)
        , Message(..)
        , Serialized
        , deserialize
        , serialize
        )

import Common.Point exposing (Point(Point))
import Game.Entities as GEntities exposing (PlayerStatus(..))


type Message
    = PlayerUpdate
    | Entity EntityAction
    | ServerStatus
    | Error


type EntityAction
    = Add GEntities.Entity
    | Update GEntities.Entity
    | Remove GEntities.Entity



-- https://danthedev.com/2015/07/25/binary-in-javascript
{-
      Old Way
      |Type|Data|
           Type 2bit
               ServerStatus 0b00
               PlayerUpdate 0b01
               ItemUpadate  0b10
           Data 30bit
               ItemUpadateData
                   Action 2bit
                       Add         0b00
                       Remove      0b01
                       Move        0b10
                       AddExplosin 0b11
                   Id 13 bit (64x64 map)
                   X 7bit
                   Y 7bit

       New Way
       |Action/ItemInfo (32bit)|Data (List of 32bit)|
       ------Action/ItemInfo0----------
           Type 2bit
               ServerStatus 0b00
               PlayerUpdate 0b01
               ItemUpadate  0b10
           ItemUpadateData
               Action 2bit
                   Add         0b00
                   Remove      0b01
                   Move        0b10
                   AddExplosin 0b11
               Id 13 bit (64x64 map)
       --------------------------------
           DataAdd
               TileType|x|y|
           DataRemove
               none
           DataMove
               |x|y|
           AddExplosin
               [(x1|y1), (x2|y2),...(xn,yn)]
   !!!!TRY SPLIT X/Y to cell where (x1,x2 - is first and second number of coordinates)
-}
-- https://codereview.stackexchange.com/questions/3569/pack-and-unpack-bytes-to-strings


type alias Serialized =
    List String



-- type alias Deserialize =
--     String


serialize : Message -> Serialized
serialize msg =
    case msg of
        PlayerUpdate ->
            [ "a" ]

        Entity (Add entity) ->
            [ "add" ] ++ fromEntity entity

        Entity _ ->
            [ "a" ]

        ServerStatus ->
            [ "a" ]

        Error ->
            [ "a" ]


deserialize : Serialized -> Message
deserialize data =
    toEntity data


fromEntity : GEntities.Entity -> List String
fromEntity e =
    case e of
        GEntities.Player { status, point, speed } ->
            let
                (Point x y) =
                    point
            in
            [ "p", toString x, toString y, status2string status, toString speed ]

        GEntities.Box (Point x y) ->
            [ "b", toString x, toString y ]

        GEntities.Wall (Point x y) ->
            [ "w", toString x, toString y ]

        _ ->
            []


toEntity : Serialized -> Message
toEntity s =
    case s of
        "add" :: "p" :: x :: y :: status :: speed :: xs ->
            add <| GEntities.Player { status = string2status status, point = point x y, speed = str2int speed }

        "add" :: "b" :: x :: y :: xs ->
            add <| GEntities.Box <| point x y

        "add" :: "w" :: x :: y :: xs ->
            add <| GEntities.Wall <| point x y

        msg ->
            let
                _ =
                    Debug.log "msg" msg
            in
            Error


status2string : PlayerStatus -> String
status2string status =
    case status of
        PlayerOnline ->
            "1"

        PlayerOffline ->
            "2"

        PlayerDead ->
            "3"


string2status : String -> PlayerStatus
string2status s =
    case s of
        "1" ->
            PlayerOnline

        "2" ->
            PlayerOffline

        "3" ->
            PlayerDead

        _ ->
            PlayerOffline


str2int : String -> Int
str2int =
    Result.withDefault 0 << String.toInt


point : String -> String -> Point
point x y =
    Point (str2int x) (str2int y)


add : GEntities.Entity -> Message
add =
    Entity
        << Add
