module Main exposing (..)

import Html 

import Builder.Model exposing (Model, model, init)
import Builder.View exposing (view)
import Builder.Update exposing (update)
import Builder.Subscriptions exposing (subscriptions)
import Builder.Message exposing (Msg)
-- http://package.elm-lang.org/packages/elm-lang/html/1.1.0/Html-App#programWithFlags
-- update to programWithFlags - to get some starting map and add some ports for webRTC ports (client/server and not for Builder)
type alias Flags = 
    { room: String
    }
flagsParser : Flags -> ( Model, Cmd Msg )
flagsParser flags = 
  init

main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = flagsParser
        , view = view
        , update = update
        , subscriptions = subscriptions
        }