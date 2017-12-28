module Server.View exposing (..)

-- import List exposing (map)
-- import Common.StatusBar as StatusBar

import Common.Background as Background
import Common.UI as UI
import Common.World.Main as World
import Html exposing (Html, div, li, text, ul)
import Html.Attributes exposing (class)
import Server.Message exposing (Msg(PlayerCount))
import Server.Model exposing (Model)


-- http://elm-lang.org/blog/blazing-fast-html-round-two - ADD lazy (if needed)


view : Model -> Html Msg
view ({ untilStart, world } as model) =
    div [ class "main-wrapper" ]
        ([ Background.view
         ]
            ++ (case untilStart of
                    Server.Model.NotSet ->
                        [ UI.playerCount PlayerCount ]

                    Server.Model.WaitForPlayers ->
                        [ World.players world |> UI.waitForPlayers ]

                    Server.Model.Seconds 0 ->
                        [ World.view world ]

                    Server.Model.Seconds s ->
                        [ World.players world |> UI.waitForPlayers, UI.countDown s ]
               )
         -- _ -> []
        )
