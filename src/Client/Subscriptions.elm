port module Client.Subscriptions exposing (subscriptions)

import Client.Message exposing (Msg(KeyDown))
import Client.Model exposing (Model)
import Keyboard


port income : (( Int, Int ) -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.downs KeyDown
        ]
