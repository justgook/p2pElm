module Client.View exposing (..)

import Client.GUI.View as GUIview
import Client.Message as Message exposing (Message)
import Client.Model as Model exposing (Model)
import Common.View.GUI.StyleDefault exposing (stylesheet)
import Element as Element
import Html exposing (Html, div)


view : Model -> Html Message
view model =
    Element.viewport stylesheet <|
        GUIview.view model.device model.page
