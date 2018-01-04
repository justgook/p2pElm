module Common.UI exposing (countDown, level, waitForPlayers)

import Common.Players.Main exposing (Player, Players, Status(..), status)
import Html exposing (Html, div, input, text)
import Html.Attributes exposing (attribute, class)
import Html.Events exposing (onClick, onInput)
import List exposing (append, map, range)


level : (Int -> msg) -> Int -> Html msg
level msg count =
    div [ class "ui-overlay" ]
        [ range 1 count
            |> map (\x -> div [ class "menu-item", onClick (msg x) ] [ div [] [] ])
            |> (\x -> List.append x [ div [ class "menu-title" ] [] ])
            -- Ugly - change to something witout lamda function
            |> div [ class "menu" ]
        ]


waitingItem : Player -> Html msg
waitingItem player =
    div
        [ class "menu-player"
        , class <|
            case status player of
                Online ->
                    "online"

                NotAvailable ->
                    "offline"

                Available ->
                    "waiting"

                Dead ->
                    "dead"
        ]
        []


countDown : Int -> Html msg
countDown time =
    div [ class "ui-count-down", attribute "data-seconds" (toString time) ] []


waitForPlayers : Players -> Html msg
waitForPlayers players =
    div [ class "ui-overlay" ]
        [ div [ class "menu" ]
            [ waitingItem players.p1
            , waitingItem players.p2
            , waitingItem players.p3
            , waitingItem players.p4
            , waitingItem players.p5
            , waitingItem players.p6
            , waitingItem players.p7
            , waitingItem players.p8
            , div [ class "menu-start" ] []
            ]
        ]
