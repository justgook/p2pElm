module Shared.Protocol
    exposing
        ( EntityAction(..)
        , Message(..)
        , Serialized
        , deserialize
        , serialize
        )

import Game.Entities as GEntities


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
    String



-- type alias Deserialize =
--     String


serialize : Message -> Serialized
serialize msg =
    case msg of
        PlayerUpdate ->
            "a"

        Entity entity ->
            "a"

        ServerStatus ->
            "a"

        Error ->
            "a"


deserialize : Serialized -> Message
deserialize data =
    Error
