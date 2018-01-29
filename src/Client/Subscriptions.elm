module Client.Subscriptions exposing (sizeToMsg, subscriptions)

-- ServerList

import Client.GUI.Main as ClientGUI
import Client.Message as Message exposing (Message)
import Client.Model exposing (Model)
import Client.Port as Port
import Element exposing (classifyDevice)
import Keyboard exposing (KeyCode)
import Shared.Protocol as Protocol
import Window


sizeToMsg : Window.Size -> Message
sizeToMsg =
    Message.Resize << classifyDevice


subscriptions : Model -> Sub Message
subscriptions model =
    Sub.batch
        [ Keyboard.downs Message.KeyDown
        , Window.resizes sizeToMsg
        , Port.client_income <| splitIncome << Protocol.deserialize
        , Port.client_serverListResponse (Message.GUI << ClientGUI.ServerList)
        ]


splitIncome : Protocol.Message -> Message
splitIncome msg =
    case msg of
        Protocol.NewConnection id ->
            Message.NewConnection id

        _ ->
            Message.Game msg
