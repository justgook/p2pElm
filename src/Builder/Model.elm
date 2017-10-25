module Builder.Model exposing (..)

import Builder.Message exposing (Msg)
import Common.Tiles.Tiles as Tiles exposing (Tiles)

type alias Model = 
  { tiles: Tiles
  }

init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )

model : Model
model = {
    tiles = Tiles.init
  }
  