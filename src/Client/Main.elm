module Main exposing (..)

import Html 

import Client.Model exposing (Model, model, init)
import Client.View exposing (view)
import Client.Update exposing (update)
import Client.Subscriptions exposing (subscriptions)
import Client.Message exposing (Msg)

main : Program Never Model Msg
main =
    Html.program
      { init = init
      , view = view
      , update = update
      , subscriptions = subscriptions
      }
