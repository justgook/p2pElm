module Common.Players.Message
    exposing
        ( Action(..)
        , Direction(..)
        , Message
        , PlayerRef(PlayerRef)
        , action
        , incomeToMessage
        , ref
        )


type PlayerRef
    = PlayerRef { index : Int }


type Message
    = Message { ref : PlayerRef, action : Action, time : Int }


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


intToRef : Int -> PlayerRef
intToRef i =
    PlayerRef { index = i }


ref : Message -> PlayerRef
ref (Message { ref }) =
    ref


action : Message -> Action
action (Message { action }) =
    action


incomeToMessage : ( Int, Int, Int ) -> Message
incomeToMessage ( pIndex, action, time ) =
    Message { ref = intToRef pIndex, action = int2action action, time = time }


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
