module Client.GUI.View.Tutorial exposing (Data, default, view)

-- import Common.View.GUI.Button exposing (button)

import Common.View.GUI.Page as Page
import Common.View.GUI.Theme exposing (ButtonStyles(..), Theme(None))
import Element exposing (Device, Element, empty, paragraph)
import Element.Attributes exposing (attribute)
import Util.I18n exposing (i18n)


type alias Data =
    { page : Int }


default : Data
default =
    { page = 1 }


view : Device -> Element Theme variation msg
view device =
    Page.view device
        { header =
            Page.header [ i18n "tutorial" ]
        , content =
            Page.content
                [ paragraph None [ attribute "data-i18n" "hello" ] [ empty ]
                ]
        , footer =
            Page.footer []
        }
