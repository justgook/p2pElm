module Client.GUI.View.Create exposing (Data, default, view)

import Common.View.GUI.Button as Button exposing (button)
import Common.View.GUI.Page as Page
import Common.View.GUI.Theme exposing (ButtonStyles(..), Theme(None))
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Input as Input
import Util.I18n exposing (i18n)


type alias Data =
    { name : String }


default : Data
default =
    { name = "" }


input : (String -> msg) -> String -> Element Theme variation msg
input onChanage value =
    Input.text None
        []
        { onChange = onChanage
        , value = value
        , label =
            Input.placeholder
                { label = Input.labelLeft (el None [ verticalCenter ] (i18n "name"))
                , text = ""
                }
        , options =
            [--Input.errorBelow (el None [] (text "This is an Error!"))
            ]
        }


view : Device -> { a | nameOnChange : String -> msg, requestList : msg, startServer : Data -> msg } -> Data -> Element Theme variation msg
view device { nameOnChange, requestList, startServer } data =
    Page.view device
        { header =
            Page.header [ i18n "create room" ]
        , content =
            Page.content
                [ input nameOnChange data.name ]
        , footer =
            [ Button.button "back" requestList
            , "start"
                |> (if String.length data.name > 3 then
                        flip Button.button (startServer data)
                    else
                        Button.disabled
                   )
            ]
                |> Page.footer
        }
