module Client.Main exposing (main)

-- import Shared.ClientPort

import Client.Message as Message exposing (Message)
import Client.Model exposing (Model, model)
import Client.Port as Port
import Client.Subscriptions exposing (sizeToMsg, subscriptions)
import Client.Update exposing (update)
import Client.View exposing (view)
import Html
import Task
import Window


main : Program Never Model Message
main =
    Html.program
        { init =
            model
                ! [ Task.perform sizeToMsg Window.size
                  , Port.serverListRequest ()
                  ]
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
