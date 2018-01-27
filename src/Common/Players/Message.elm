module Common.Players.Message
    exposing
        ( Action(..)
        , Direction(..)
        , Message(Message)
        , action
        , incomeToMessage
        , ref
        )


type Message
    = Message { ref : Int, action : Action, time : Int }


ref : Message -> Int
ref (Message { ref }) =
    ref


type Direction
    = North
    | East
    | South
    | West


type Action
    = Connected
    | Disconnected
    | Move Direction
    | Bomb
    | Error


action : Message -> Action
action (Message { action }) =
    action


incomeToMessage : ( Int, Int, Int ) -> Message
incomeToMessage ( pIndex, action, time ) =
    Message { ref = pIndex, action = int2action action, time = time }


int2action : Int -> Action
int2action i =
    case i of
        0 ->
            Connected

        1 ->
            Disconnected

        2 ->
            Move North

        3 ->
            Move East

        4 ->
            Move South

        5 ->
            Move West

        6 ->
            Bomb

        _ ->
            Error
