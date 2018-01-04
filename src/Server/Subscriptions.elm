port module Server.Subscriptions exposing (subscriptions)

-- import Common.World.Main exposing (players)

import Common.Players.Message exposing (Message, incomeToMessage)
import Server.Model exposing (Model)
import Server.Update exposing (Msg(PlayerAction))


port income : (( Int, Int, Int ) -> msg) -> Sub msg



-- https://gist.github.com/r-k-b/e589b02d68cab07af63347507c8d0a2d
-- Task.perform never TimeSuccess Time.now


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ incomeToMessage >> PlayerAction |> income
        ]



-- requestIdleCallback
