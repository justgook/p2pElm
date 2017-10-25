port module Server.Update exposing (..)

import Server.Model exposing(Model)
import Server.Message exposing (Msg(PlayerAction))
-- import Common.Players.Model exposing (updatePlayer)

port broadcast : String -> Cmd msg


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
 case msg of
    PlayerAction (index, action) ->
      let
        -- Connected: 0,
        -- Disconnected: 1,
        -- Up: 2,
        -- Right: 3,
        -- Down: 4,
        -- Left: 5,
        -- Bomb: 6,
        -- Error: 7,

        _ = case action of
          0 -> Debug.log "Connected" index
          1 -> Debug.log "Disconnected" index
          2 -> Debug.log "Up" index
          3 -> Debug.log "Right" index
          4 -> Debug.log "Down" index
          5 -> Debug.log "Left" index
          6 -> Debug.log "Bomb" index
          e -> Debug.log "Got Error"  e
      in
      case action of
        -- 0 -> ({model | players = updatePlayer model.players (index, action)}, Cmd.none)
        -- 1 -> ({model | players = updatePlayer model.players (index, action)}, Cmd.none)
        _ -> (model, Cmd.none)
