module Server.View exposing (..)

-- import List exposing (map)
-- import Common.StatusBar as StatusBar

import Common.Background as Background
import Common.UI as UI
import Common.World.Main as World
import Common.World.View as World
import Html exposing (Html, div, li, text, ul)
import Html.Attributes exposing (class)
import Server.Model exposing (Model)
import Server.Update exposing (Msg(NoLevel))
import Server.Update.NoLevel as NoLevel


-- http://elm-lang.org/blog/blazing-fast-html-round-two - ADD lazy (if needed)


view : Model -> Html Msg
view model =
    (case ( model.world, model.untilStart ) of
        ( Just world, Server.Model.Seconds 0 ) ->
            [ World.view (World.tiles world) (World.players world) ]

        ( Just world, Server.Model.Seconds s ) ->
            [ World.players world |> UI.waitForPlayers, UI.countDown s ]

        ( Just world, _ ) ->
            [ World.players world |> UI.waitForPlayers ]

        -- ( Nothing, _ ) ->
        _ ->
            List.length model.rooms
                |> UI.level (NoLevel << NoLevel.Level)
                |> List.singleton
    )
        |> (::) Background.view
        |> div [ class "main-wrapper" ]



-- |>  div [ class "main-wrapper" ]
-- |> (++) (case world of
--     Just w -> []
--     Nothing -> [])
-- ++ (case untilStart of
--         Server.Model.NotSet ->
--             [ UI.playerCount PlayerCount ]
--         Server.Model.WaitForPlayers ->
--             [ World.players world |> UI.waitForPlayers ]
--         Server.Model.Seconds 0 ->
--             [ World.view world ]
--         Server.Model.Seconds s ->
--             [ World.players world |> UI.waitForPlayers, UI.countDown s ]
--    )
-- _ -> []
