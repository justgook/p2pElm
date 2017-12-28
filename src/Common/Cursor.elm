module Common.Cursor exposing (..)

import Common.Point exposing (Point)


-- import Keyboard exposing (KeyCode)
-- import Time exposing (Time)


type Direction
    = Up
    | Right
    | Down
    | Left


type Msg
    = Cursor Direction


type alias Model =
    Point


model : Model
model =
    { x = 0
    , y = 0
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        Cursor dir ->
            case dir of
                -- 0,0 is top left
                Up ->
                    { model | y = model.y - 1 }

                Right ->
                    { model | y = model.x + 1 }

                Down ->
                    { model | y = model.y + 1 }

                Left ->
                    { model | y = model.x - 1 }
