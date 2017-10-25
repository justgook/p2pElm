module Builder.Message exposing (..)

import Keyboard exposing (KeyCode)
import Time exposing (Time)


type Msg = Increment | Decrement | TimeUpdate Time | KeyDown KeyCode