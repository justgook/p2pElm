port module Server.Subscriptions exposing (subscriptions)

-- import AnimationFrame
import Server.Message exposing (Msg(PlayerAction))
import Server.Model exposing (Model)
-- import Keyboard

port suggestions : (List String -> msg) -> Sub msg
port income : ((Int, Int) -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ income PlayerAction
    ]
    -- requestIdleCallback