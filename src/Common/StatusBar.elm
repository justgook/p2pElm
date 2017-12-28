module Common.StatusBar exposing (view)

-- import List exposing (map, range, append)
-- import Html.Attributes exposing (class, classList, style)

import Common.Players.Model exposing (Players)
import Common.Players.View as Avatar
import Html exposing (Html, div, li, text, ul)


-- display


view : Players -> Html Never
view players =
    [ Avatar.view players.p1 1
    , Avatar.view players.p2 2
    , Avatar.view players.p3 3
    , Avatar.view players.p4 4
    , Avatar.view players.p5 5
    , Avatar.view players.p6 6
    , Avatar.view players.p7 7
    , Avatar.view players.p8 8
    ]
        |> div []



-- <| div []  --(map Avatar.view (range 1 8))
-- div[class "avatar"][]
