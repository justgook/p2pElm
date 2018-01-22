module Client.GUI.View.Settings exposing (..)

import Common.View.GUI.Button as Button
import Common.View.GUI.Page as Page
import Common.View.GUI.Theme exposing (ButtonStyles(..), Theme(None))
import Element exposing (el, empty, paragraph, row, text)
import Element.Attributes exposing (..)
import Element.Events exposing (..)
import Util.I18n exposing (i18n)


-- http://pixelastic.github.io/css-flags/


view : Element.Device -> Element.Element Theme variation msg
view device =
    Page.view device
        { header =
            Page.header []
        , content =
            -- [ ( "languages", Cmd.none ) ]
            --     |> Button.fromList
            []
                |> Page.content
        , footer =
            -- [ ( "close", Cmd.none ) ]
            --     |> Button.fromList
            []
                |> Page.footer
        }
