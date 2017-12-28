module Common.Players.Main
    exposing
        ( Action(..)
        , Direction(..)
        , Message
        , Player
        , PlayerRef
        , Players
        , Status(..)
        , action
        , add
        , bombReturn
        , bombsTime
        , empty
        , incomeToMessage
        , movePlayer
        , newPosition
        , placeBomb
          -- , playerByMessage
        , playerByRef
        , playerRefByMessage
        , possition
        , status
        , tiles
        , updatePlayers
        )

import Common.Point exposing (Point(Point))


type Action
    = Connected
    | Disconnected
    | Move Direction
    | Bomb
    | Error


action : Message -> Action
action (Message { action }) =
    action


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


type Message
    = Message { ref : PlayerRef, action : Action }


incomeToMessage : ( Int, Int ) -> Message
incomeToMessage ( pIndex, action ) =
    Message { ref = PlayerRef { index = pIndex }, action = int2action action }


type Direction
    = North
    | East
    | South
    | West


type Bombs
    = Bombs { left : Int, explosionTime : Float, explosionSize : Int }


type Status
    = Online
    | NotAvailable
    | Available


type Player
    = Player
        { possition : Point
        , direction : Direction
        , status : Status
        , bombs : Bombs
        , speed : Int
        , index : Int
        }


type PlayerRef
    = PlayerRef { index : Int }


status : Player -> Status
status (Player { status }) =
    status


possition : Player -> Point
possition (Player { possition }) =
    possition


bombsTime : Player -> Float
bombsTime (Player { bombs }) =
    let
        (Bombs { left, explosionTime }) =
            bombs
    in
    explosionTime



-- TODO move to Players.Server part


bombReturn : Players -> PlayerRef -> Players
bombReturn players ref =
    let
        (Bombs { left, explosionTime, explosionSize }) =
            bombs

        (Player { status, bombs, speed, possition, index, direction }) =
            playerByRef players ref
    in
    players
        |> replacePlayer ref
            (Player
                { status = status
                , direction = direction
                , bombs = Bombs { left = left + 1, explosionTime = explosionTime, explosionSize = explosionSize }
                , speed = speed
                , possition = possition
                , index = index
                }
            )


placeBomb : Players -> PlayerRef -> Maybe ( Players, { point : Point, explosionTime : Float, explosionSize : Int } )
placeBomb players ref =
    let
        (Player { status, direction, bombs, speed, possition, index }) =
            playerByRef players ref

        (Bombs { left, explosionTime, explosionSize }) =
            bombs
    in
    case left of
        0 ->
            Nothing

        _ ->
            let
                newPlayer =
                    Player
                        { status = status
                        , direction = direction
                        , bombs = Bombs { left = left - 1, explosionTime = explosionTime, explosionSize = explosionSize }
                        , speed = speed
                        , possition = possition
                        , index = index
                        }
            in
            Just ( replacePlayer ref newPlayer players, { point = possition, explosionTime = explosionTime, explosionSize = explosionSize } )


possitionByMessage : Players -> Message -> Point
possitionByMessage pls msg =
    playerByMessage pls msg |> possition


type alias Players =
    { p1 : Player
    , p2 : Player
    , p3 : Player
    , p4 : Player
    , p5 : Player
    , p6 : Player
    , p7 : Player
    , p8 : Player
    }


playerRefByMessage : Message -> PlayerRef
playerRefByMessage (Message { ref }) =
    ref


playerByMessage : Players -> Message -> Player
playerByMessage p (Message { ref }) =
    playerByRef p ref


replacePlayer : PlayerRef -> Player -> Players -> Players
replacePlayer (PlayerRef { index }) newPlayer players =
    case index of
        0 ->
            { players | p1 = newPlayer }

        1 ->
            { players | p2 = newPlayer }

        2 ->
            { players | p3 = newPlayer }

        3 ->
            { players | p4 = newPlayer }

        4 ->
            { players | p5 = newPlayer }

        5 ->
            { players | p6 = newPlayer }

        6 ->
            { players | p7 = newPlayer }

        7 ->
            { players | p8 = newPlayer }

        _ ->
            players


playerByRef : Players -> PlayerRef -> Player
playerByRef { p1, p2, p3, p4, p5, p6, p7, p8 } (PlayerRef { index }) =
    case index of
        0 ->
            p1

        1 ->
            p2

        2 ->
            p3

        3 ->
            p4

        4 ->
            p5

        5 ->
            p6

        6 ->
            p7

        7 ->
            p8

        _ ->
            p1


add : Players -> Point -> Players
add ({ p1, p2, p3, p4, p5, p6, p7, p8 } as players) point =
    if statusNotAvailable p1 then
        { players | p1 = createPlayer p1 point }
    else if statusNotAvailable p2 then
        { players | p2 = createPlayer p2 point }
    else if statusNotAvailable p3 then
        { players | p3 = createPlayer p3 point }
    else if statusNotAvailable p4 then
        { players | p4 = createPlayer p4 point }
    else if statusNotAvailable p5 then
        { players | p5 = createPlayer p5 point }
    else if statusNotAvailable p6 then
        { players | p6 = createPlayer p6 point }
    else if statusNotAvailable p7 then
        { players | p7 = createPlayer p7 point }
    else if statusNotAvailable p8 then
        { players | p8 = createPlayer p8 point }
    else
        players


tiles : Players -> List { point : Point, direction : Direction, id : Int }
tiles ({ p1, p2, p3, p4, p5, p6, p7, p8 } as players) =
    tilesAppender 1 p1 <|
        tilesAppender 2 p2 <|
            tilesAppender 3 p3 <|
                tilesAppender 4 p4 <|
                    tilesAppender 5 p5 <|
                        tilesAppender 6 p6 <|
                            tilesAppender 7 p7 <|
                                tilesAppender 8 p8 []


empty : Players
empty =
    let
        player i =
            Player
                { index = i
                , direction = North
                , status = NotAvailable
                , bombs = Bombs { left = 3, explosionTime = 3, explosionSize = 1 }
                , speed = 10
                , possition = Point 0 0
                }
    in
    { p1 = player 0
    , p2 = player 1
    , p3 = player 2
    , p4 = player 3
    , p5 = player 4
    , p6 = player 5
    , p7 = player 6
    , p8 = player 7
    }


statusNotAvailable : Player -> Bool
statusNotAvailable (Player { status }) =
    status == NotAvailable


direction : Player -> Direction
direction (Player { direction }) =
    direction


tilesAppender : Int -> Player -> List { direction : Direction, id : Int, point : Point } -> List { direction : Direction, id : Int, point : Point }
tilesAppender id player tiles =
    if not (statusNotAvailable player) then
        { point = possition player, direction = direction player, id = id } :: tiles
    else
        tiles


createPlayer : Player -> Point -> Player
createPlayer (Player { bombs, speed, index, direction }) p =
    Player
        { status = Available
        , direction = direction
        , bombs = bombs
        , speed = speed
        , possition = p
        , index = index
        }


updatePlayers : Players -> Message -> Players
updatePlayers players (Message { ref, action }) =
    let
        update =
            \p -> playerUpdater (p players) action

        (PlayerRef { index }) =
            ref
    in
    case index of
        0 ->
            { players | p1 = update .p1 }

        1 ->
            { players | p2 = update .p2 }

        2 ->
            { players | p3 = update .p3 }

        3 ->
            { players | p4 = update .p4 }

        4 ->
            { players | p5 = update .p5 }

        5 ->
            { players | p6 = update .p6 }

        6 ->
            { players | p7 = update .p7 }

        7 ->
            { players | p8 = update .p8 }

        _ ->
            players


newPosition : Players -> Message -> Point
newPosition players ((Message { action }) as m) =
    action
        |> playerUpdater (playerByMessage players m)
        |> possition


movePlayer : Player -> Direction -> Player
movePlayer ((Player { bombs, speed, status, possition, index }) as player) dir =
    let
        (Point x y) =
            possition
    in
    case dir of
        North ->
            Player { index = index, direction = dir, status = status, bombs = bombs, speed = speed, possition = Point x (y - 1) }

        East ->
            Player { index = index, direction = dir, status = status, bombs = bombs, speed = speed, possition = Point (x + 1) y }

        South ->
            Player { index = index, direction = dir, status = status, bombs = bombs, speed = speed, possition = Point x (y + 1) }

        West ->
            Player { index = index, direction = dir, status = status, bombs = bombs, speed = speed, possition = Point (x - 1) y }


playerUpdater : Player -> Action -> Player
playerUpdater ((Player { bombs, speed, status, possition, index, direction }) as player) action =
    case action of
        Connected ->
            Player { index = index, direction = direction, status = Online, bombs = bombs, speed = speed, possition = possition }

        Disconnected ->
            Player { index = index, direction = direction, status = Available, bombs = bombs, speed = speed, possition = possition }

        Move d ->
            movePlayer player d

        _ ->
            player
