module Client.Model exposing (Model, model)

import Client.GUI.Main as GUI
import Client.Game.Main as Game
import Element exposing (Device, classifyDevice)


type alias Model =
    { device : Device
    , gui : GUI.Model
    , game : Game.Model
    }


model : Model
model =
    { device = classifyDevice { width = 0, height = 0 }
    , gui = GUI.model
    , game = Game.model
    }
