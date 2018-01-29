module Client.Message exposing (..)

import Client.GUI.Main as ClientGUI
import Client.GUI.View.Create as CreateGUI
import Client.Game.Main as Game
import Element exposing (Device)
import Keyboard exposing (KeyCode)
import Navigation exposing (Location)


type Message
    = Resize Device
    | KeyDown KeyCode
    | Location Location
    | GUI ClientGUI.Msg
    | Game Game.Message
    | NewConnection Int


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
    --TODO Maybe move that part to mapping of Element
    { join = GUI << ClientGUI.Join
    , requestList = GUI ClientGUI.RequestServerList
    , startServer = GUI << ClientGUI.Creating << ClientGUI.End
    , startCreate = GUI (ClientGUI.Creating ClientGUI.Start)
    , nameOnChange = GUI << ClientGUI.Creating << ClientGUI.OnNameChange
    , showTutorial = GUI ClientGUI.ShowTutorial
    , showSettings = GUI ClientGUI.ShowSettings
    }
