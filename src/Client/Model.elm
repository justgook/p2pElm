module Client.Model exposing (..)

import Client.Message exposing (Msg)

type alias Model = {}

init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )
model : Model
model = {}
  