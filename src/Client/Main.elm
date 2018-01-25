module Client.Main exposing (main)

-- import Shared.ClientPort
-- import Html

import Client.Message as Message exposing (Message)
import Client.Model exposing (Model, model)
import Client.Port as Port
import Client.Subscriptions exposing (sizeToMsg, subscriptions)
import Client.Update exposing (update)
import Client.View exposing (view)
import Navigation exposing (program)
import Task
import Window


-- main : Program Never Model Message


main : Program Never Model Message
main =
    program
        Message.Location
        { init =
            \location ->
                model
                    ! [ Task.perform sizeToMsg Window.size
                      , Port.client_serverListRequest ()
                      ]
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
