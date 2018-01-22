module Client.Message exposing (..)

import Client.GUI.Main as ClientGUI
import Client.GUI.View.Create as CreateGUI
import Element exposing (Device)
import Keyboard exposing (KeyCode)
import Shared.Protocol as Protocol


type Message
    = Resize Device
    | KeyDown KeyCode
    | GUI ClientGUI.Msg
    | Income Protocol.Message


type alias Actions =
    { join : String -> Message
    , nameOnChange : String -> Message
    , requestList : Message
    , startCreate : Message
    , startServer : CreateGUI.Data -> Message
    , showTutorial : Message
    , showSettings : Message
    }


actions : Actions
actions =
    { join = GUI << ClientGUI.Join
    , requestList = GUI ClientGUI.RequestServerList
    , startServer = GUI << ClientGUI.Creating << ClientGUI.End
    , startCreate = GUI (ClientGUI.Creating ClientGUI.Start)
    , nameOnChange = GUI << ClientGUI.Creating << ClientGUI.OnNameChange
    , showTutorial = GUI ClientGUI.ShowTutorial
    , showSettings = GUI ClientGUI.ShowSettings
    }
