module Common.View.GUI.Button exposing (button, disabled, fromList)

-- import Common.View.GUI.Style exposing (scaled, stylesheet)

import Common.View.GUI.Theme as Theme exposing (ButtonStyles(..), Theme(..))
import Element as Element exposing (Device, Element, column, el, empty, modal, row, screen, text, within)
import Element.Attributes as Attributes exposing (attribute, center, fill, height, padding, paddingXY, percent, spacing, verticalCenter, width)
import Element.Events exposing (onClick)


button : String -> msg -> Element Theme variation msg
button t msg =
    Element.button (Button Active) [ onClick msg, paddingXY 16 16, attribute "data-i18n" t ] empty


disabled : String -> Element Theme variation msg
disabled t =
    Element.button (Button Disabled) [ paddingXY 16 16, attribute "data-i18n" t ] empty


fromList : List ( String, msg ) -> List (Element Theme variation msg)
fromList items =
    List.map (uncurry button) items
