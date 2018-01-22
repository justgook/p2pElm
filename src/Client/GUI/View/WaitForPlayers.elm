module Client.GUI.View.WaitForPlayers exposing (Data, default, view)

-- import Common.View.GUI.Button exposing (button)
-- import Element.Attributes exposing (..)
-- import Element.Events exposing (..)

import Common.View.GUI.Page as Page
import Common.View.GUI.Theme exposing (ButtonStyles(..), Theme(None))
import Element exposing (Device, Element, el, empty, paragraph, row, text)
import Util.I18n exposing (i18n)


type alias Item =
    Bool


type alias Data =
    List Item


default : Data
default =
    []


item : Item -> Element style variation msg
item i =
    text "1"


view : Device -> Data -> Element Theme variation msg
view device data =
    Page.view device
        { header =
            Page.header [ i18n "wait for players" ]
        , content =
            Page.grid <| List.map item data
        , footer =
            Page.footer []
        }
