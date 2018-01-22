module Client.GUI.View.GameList exposing (Data, default, view)

import Common.View.GUI.Button as Button
import Common.View.GUI.Page as Page
import Common.View.GUI.Theme exposing (ButtonStyles(..), Theme(None))
import Element exposing (Device, Element, el, empty, paragraph, row, text)
import Element.Attributes exposing (..)
import Element.Events exposing (..)
import Util.I18n exposing (i18n)


type alias Game =
    { id : String
    , totalSlots : Int
    , freeSlots : Int
    , name : String
    }


type alias Data =
    List Game


default : Data
default =
    []


data2row : (String -> msg) -> Game -> Element.Element Theme variation msg
data2row msg data =
    row None
        [ spread, width fill, paddingXY 16 0, onClick (msg data.id) ]
        [ data.id |> text
        , data.name |> text
        , "(" ++ toString data.freeSlots ++ "/" ++ toString data.totalSlots ++ ")" |> text
        ]


view : Device -> { a | join : String -> msg, showSettings : msg, showTutorial : msg, startCreate : msg } -> List Game -> Element Theme variation msg
view device actions data =
    let
        data2row2 =
            data2row actions.join
    in
    Page.view device
        { header =
            Page.header [ i18n "select level" ]
        , content =
            case data of
                [] ->
                    Page.content <| [ i18n "no games" ]

                _ ->
                    Page.list <| List.map data2row2 data
        , footer =
            [ ( "tutorial", actions.showTutorial )
            , ( "create", actions.startCreate )
            , ( "settings", actions.showSettings )
            ]
                |> Button.fromList
                |> Page.footer
        }
