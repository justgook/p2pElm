port module Server.Subscriptions exposing (subscriptions)

-- import Common.World.Main exposing (players)

import Common.Players.Main exposing (Message, incomeToMessage)
import Server.Message exposing (Msg(PlayerAction))
import Server.Model exposing (Model)


port income : (( Int, Int ) -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        -- TODO make it clear and witouth that ugly "let/in"
        parsing ( a, b ) =
            PlayerAction <| incomeToMessage ( a, b )
    in
    Sub.batch
        [ income parsing
        ]



-- requestIdleCallback
