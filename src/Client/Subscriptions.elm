module Client.Subscriptions exposing (sizeToMsg, subscriptions)

-- ServerList
-- import Shared.Protocol as Protocol

import Client.GUI.Main as ClientGUI
import Client.Message as Message exposing (Message)
import Client.Model exposing (Model)
import Client.Port as Port
import Element exposing (classifyDevice)
import Keyboard exposing (KeyCode)
import Window


sizeToMsg : Window.Size -> Message
sizeToMsg =
    Message.Resize << classifyDevice


subscriptions : Model -> Sub Message
subscriptions model =
    Sub.batch
        [ Keyboard.downs Message.KeyDown
        , Window.resizes sizeToMsg

        -- , Port.levelUpdate <| Message.Income << Protocol.deserialize
        , Port.serverListResponse (Message.GUI << ClientGUI.ServerList)
        ]
