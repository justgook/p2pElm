module Server.Model exposing (..)

import Server.Message exposing (Msg)
import Common.World.Main as World exposing (World)
import Common.Players.Model as Players exposing (Players)

type alias Model =
  { world: World
  }

init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )

model : Model
model =
  { world = World.init
  }
