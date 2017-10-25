module Main exposing (..)

import Html

import Server.Model exposing (Model, model, init)
import Server.View exposing (view)
import Server.Update exposing (update)
import Server.Subscriptions exposing (subscriptions)
import Server.Message exposing (Msg)
import Common.World.Main exposing (decode)
-- http://package.elm-lang.org/packages/elm-lang/html/1.1.0/Html-App#programWithFlags
-- update to programWithFlags - to get some starting map and add some ports for webRTC ports (client/server and not for Builder)
type alias Flags =
  { room: String
  }
flagsParser : Flags -> ( Model, Cmd Msg )
flagsParser flags =
    ({model | world = decode flags.room}, Cmd.none)

main : Program Flags Model Msg
main =
  Html.programWithFlags
    { init = flagsParser
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
