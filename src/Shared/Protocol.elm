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
    | Remove GEntities.Id



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
        GEntities.Player n { status, point, speed, bombsLeft, explosionTime, explosionSize } ->
            let
                (Point x y) =
                    point
            in
            [ "1"
            , toString n
            , toString x
            , toString y
            , status2string status
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

        --
        _ ->
            []


toEntity : Serialized -> Message
toEntity s =
    case s of
        "add" :: "1" :: n :: x :: y :: status :: speed :: bombsLeft :: explosionTime :: explosionSize :: [] ->
            add <|
                GEntities.Player (str2int n)
                    { status = string2status status
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
