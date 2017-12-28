module Main exposing (..)

import Client.Message exposing (Msg)
import Client.Model exposing (Model, init, model)
import Client.Subscriptions exposing (subscriptions)
import Client.Update exposing (update)
import Client.View exposing (view)
import Html


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
