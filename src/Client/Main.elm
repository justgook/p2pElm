module Client.Main exposing (main)

import Client.GUI.Main as ClientGUI
import Client.Message as Message exposing (Message)
import Client.Model exposing (Model, model)
import Client.Subscriptions exposing (sizeToMsg, subscriptions)
import Client.Update exposing (update)
import Client.View exposing (view)
import Navigation exposing (Location, program)
import Task
import Window


main : Program Never Model Message
main =
    program
        Message.Location
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : Location -> ( Model, Cmd Message )
init location =
    let
        ( newModel, cmd ) =
            update (Message.GUI (ClientGUI.Init location)) model
    in
    newModel
        ! [ cmd
          , Task.perform sizeToMsg Window.size
          ]
