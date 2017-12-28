module Common.Players.View exposing (view)

-- import String exposing (toString)

import Common.Players.Model exposing (Player, Status(..), status)
import Html exposing (Html, div, li, text, ul)
import Html.Attributes exposing (class, classList, style)


emptyNode : Html msg
emptyNode =
    Html.text ""


view : Player -> Int -> Html msg
view player index =
    case status player of
        -- Online
        -- NotAvailable
        -- Available
        Online ->
            div [ class "avatar", class ("p" ++ toString index) ]
                [ div [ class "Char" ]
                    [ div [ class "Char-head" ]
                        [ div [ class "Char-face" ]
                            [ div [ class "Char-eyes" ]
                                [ div [ class "Char-eye" ]
                                    []
                                , div [ class "Char-eye" ]
                                    []
                                ]
                            ]
                        , div [ class "Char-hair" ]
                            []
                        ]
                    ]
                ]

        _ ->
            emptyNode
