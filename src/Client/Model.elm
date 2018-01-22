module Client.Model exposing (Model, model)

import Client.GUI.Main as ClientGUI
import Element exposing (Device, classifyDevice)


type alias Model =
    { device : Device
    , page : ClientGUI.Model
    }


model : Model
model =
    { device = classifyDevice { width = 0, height = 0 }
    , page = ClientGUI.None
    }
