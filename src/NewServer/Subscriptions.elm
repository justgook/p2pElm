port module NewServer.Subscriptions exposing (subscriptions)

-- import Common.World.Main exposing (players)

import Common.Players.Message exposing (Message, incomeToMessage)
import NewServer.Port as Port
import NewServer.Update as Server exposing (Model, Msg(PlayerAction))


-- https://gist.github.com/r-k-b/e589b02d68cab07af63347507c8d0a2d
-- Task.perform never TimeSuccess Time.now
-- Port.toServerRestart


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ incomeToMessage >> PlayerAction |> Port.server_income
        , Port.server_start Server.Start
        ]
