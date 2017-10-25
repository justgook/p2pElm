module Builder.Subscriptions exposing (..)

-- import AnimationFrame
import Builder.Message exposing (Msg(KeyDown))
import Builder.Model exposing (Model)
import Keyboard

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Keyboard.downs KeyDown
        --, AnimationFrame.diffs TimeUpdate
    ]

    -- requestIdleCallback