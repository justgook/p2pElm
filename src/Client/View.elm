module Client.View exposing (..)

-- import Client.Message as Message exposing (Message)

import Client.GUI.View as GUIview
import Client.Game.StyleDefault as Game
import Client.Game.Theme as Game
import Client.Game.View as Game
import Client.Message exposing (Message)
import Client.Model as Model exposing (Model)
import Common.View.GUI.StyleDefault as GUI
import Common.View.GUI.Theme as GUI
import Element as Element exposing (empty, screen, within)
import Html exposing (Html, div)
import Style exposing (StyleSheet)
import Style.Sheet as Sheet


type Theme
    = GuiTheme GUI.Theme
    | GameTheme Game.Theme


stylesheet : StyleSheet Theme Never
stylesheet =
    [ Sheet.map GuiTheme Basics.never GUI.stylesheet
    , Sheet.map GameTheme Basics.never Game.stylesheet
    ]
        |> List.map Sheet.merge
        |> Style.styleSheet


view : Model -> Html Message
view model =
    empty
        |> within
            [ Element.mapAll Basics.never GameTheme Basics.never (Game.view model.device model.game)
            , Element.mapAll identity GuiTheme Basics.never (GUIview.view model.device model.gui)
            ]
        |> Element.viewport stylesheet



--
--
