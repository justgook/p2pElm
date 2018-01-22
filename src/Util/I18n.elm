module Util.I18n exposing (i18n)

import Common.View.GUI.Theme as Theme exposing (Theme(None))
import Element as Element exposing (Element, el, empty)
import Element.Attributes as Attributes exposing (attribute)


i18n : String -> Element Theme variation msg
i18n t =
    el None [ attribute "data-i18n" t ] empty
