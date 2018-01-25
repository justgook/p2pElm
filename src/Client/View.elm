module Client.View exposing (..)

import Client.GUI.View as GUIview
import Client.Game.StyleDefault as Game
import Client.Game.Theme as Game
import Client.Game.View as Game
import Client.Message as Message exposing (Message)
import Client.Model as Model exposing (Model)
import Common.View.GUI.StyleDefault as GUI
import Common.View.GUI.Theme as GUI
import Element as Element exposing (empty, screen, within)
import Html exposing (Html, div)
import Style exposing (StyleSheet)
import Style.Sheet as Sheet


type Variation
    = GuiVariation GUI.Variation
    | GameVariation Game.Variation


type Theme
    = GuiTheme GUI.Theme
    | GameTheme Game.Theme


stylesheet : StyleSheet Theme Variation
stylesheet =
    [ Sheet.map GuiTheme GuiVariation GUI.stylesheet
    , Sheet.map GameTheme GameVariation Game.stylesheet
    ]
        |> List.map Sheet.merge
        |> Style.styleSheet


view : Model -> Html Message
view model =
    empty
        |> within
            [ Element.mapAll identity GameTheme GameVariation (Game.view model.device model.game)
            , Element.mapAll identity GuiTheme GuiVariation (GUIview.view model.device model.gui)
            ]
        |> Element.viewport stylesheet



--
--
