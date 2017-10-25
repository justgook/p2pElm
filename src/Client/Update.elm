port module Client.Update exposing (..)

import Client.Model exposing(Model)
import Client.Message exposing (Msg(KeyDown))

port did : Int -> Cmd msg


        -- Connected: 0,
        -- Disconnected: 1,
        -- Up: 2,
        -- Right: 3,
        -- Down: 4,
        -- Left: 5,
        -- Bomb: 6,
        -- Error: 7,

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
 case msg of
    KeyDown key ->
      let 
        _ = Debug.log "KeyDown" key
        action = case key of 
          38 -> did 2
          39 -> did 3
          40 -> did 4
          37 -> did 5
          32 -> did 6
          _ -> Cmd.none
      in
        ( model, action ) -- sending out 
