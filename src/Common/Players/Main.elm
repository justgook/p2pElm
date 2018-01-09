module Common.Players.Main
    exposing
        ( LivePlayersDict
        , Player
        , Players
        , Status(..)
        , add
          -- , bombReturn
        , bombsSize
          -- , placeBomb
        , bombsTime
        , count
        , decreaseBombCount
        , die
        , empty
        , increaseBombCount
        , isLive
        , livePlayersDict
        , newPosition
        , playerByMessage
        , playerByRef
        , possition
        , set
        , status
        , tiles
        , updatePlayers
        )

import Common.Players.Message as Message exposing (Action(..), Direction(..), Message, PlayerRef(PlayerRef), action)
import Common.Point exposing (Point(Point))
import Dict exposing (Dict)


type Bombs
    = Bombs { left : Int, explosionTime : Float, explosionSize : Int }


type Status
    = Online
    | NotAvailable
    | Available
    | Dead


type Player
    = Player
        { possition : Point
        , direction : Direction
        , status : Status
        , bombs : Bombs
        , speed : Int
        , index : Int
        }


status : Player -> Status
status (Player { status }) =
    status


possition : Player -> Point
possition (Player { possition }) =
    possition


bombsTime : Player -> Float
bombsTime (Player { bombs }) =
    let
        (Bombs { explosionTime }) =
            bombs
    in
    explosionTime


bombsSize : Player -> Int
bombsSize (Player { bombs }) =
    let
        (Bombs { explosionSize }) =
            bombs
    in
    explosionSize


increaseBombCount : Player -> Player
increaseBombCount (Player player) =
    let
        (Bombs ({ left, explosionTime } as bombs)) =
            player.bombs
    in
    Player { player | bombs = Bombs { bombs | left = left + 1 } }


decreaseBombCount : Player -> Maybe Player
decreaseBombCount (Player player) =
    let
        (Bombs ({ left, explosionTime } as bombs)) =
            player.bombs
    in
    if left > 0 then
        Just <| Player { player | bombs = Bombs { bombs | left = left - 1 } }
    else
        Nothing


possitionByMessage : Players -> Message -> Point
possitionByMessage pls msg =
    playerByMessage msg pls |> possition


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


type alias LivePlayersDict =
    Dict ( Int, Int ) PlayerRef


livePlayersDict : Players -> LivePlayersDict
livePlayersDict ({ p1, p2, p3, p4, p5, p6, p7, p8 } as players) =
    []
        |> livePlayerTuple p1
        |> livePlayerTuple p2
        |> livePlayerTuple p3
        |> livePlayerTuple p4
        |> livePlayerTuple p5
        |> livePlayerTuple p6
        |> livePlayerTuple p7
        |> livePlayerTuple p8
        |> Dict.fromList


livePlayerTuple : Player -> List ( ( Int, Int ), PlayerRef ) -> List ( ( Int, Int ), PlayerRef )
livePlayerTuple (Player { possition, index, status }) =
    let
        (Point x y) =
            possition
    in
    addIf (status == Online) ( ( x, y ), PlayerRef { index = index } )


isLive : Player -> Bool
isLive (Player { status }) =
    status == Online


playerByMessage : Message -> Players -> Player
playerByMessage msg p =
    playerByRef (Message.ref msg) p


playerByRef : PlayerRef -> Players -> Player
playerByRef (PlayerRef { index }) { p1, p2, p3, p4, p5, p6, p7, p8 } =
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


add : Point -> Players -> Players
add point ({ p1, p2, p3, p4, p5, p6, p7, p8 } as players) =
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


die : Player -> Player
die (Player data) =
    Player { data | status = Dead }


set : Player -> Players -> Players
set ((Player { index }) as p) players =
    case index of
        0 ->
            { players | p1 = p }

        1 ->
            { players | p2 = p }

        2 ->
            { players | p3 = p }

        3 ->
            { players | p4 = p }

        4 ->
            { players | p5 = p }

        5 ->
            { players | p6 = p }

        6 ->
            { players | p7 = p }

        7 ->
            { players | p8 = p }

        _ ->
            players


count : Players -> Int
count { p1, p2, p3, p4, p5, p6, p7, p8 } =
    if statusNotAvailable p1 then
        0
    else if statusNotAvailable p2 then
        1
    else if statusNotAvailable p3 then
        2
    else if statusNotAvailable p4 then
        3
    else if statusNotAvailable p5 then
        4
    else if statusNotAvailable p6 then
        5
    else if statusNotAvailable p7 then
        6
    else if statusNotAvailable p8 then
        7
    else
        8


tiles : Players -> List { point : Point, direction : Direction, id : Int, status : Status }
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
                , bombs = Bombs { left = 3, explosionTime = 3, explosionSize = 10 }
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


tilesAppender : Int -> Player -> List { direction : Direction, id : Int, point : Point, status : Status } -> List { direction : Direction, id : Int, point : Point, status : Status }
tilesAppender id player tiles =
    if not (statusNotAvailable player) then
        { point = possition player, direction = direction player, id = id, status = status player } :: tiles
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
updatePlayers players msg =
    let
        update =
            \p -> playerUpdater (p players) (Message.action msg)

        (PlayerRef { index }) =
            Message.ref msg
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
newPosition players m =
    let
        action =
            Message.action m

        player =
            playerByMessage m players
    in
    playerUpdater player action
        |> possition


movePlayer : Player -> Direction -> Player
movePlayer (Player ({ possition } as player)) dir =
    let
        (Point x y) =
            possition
    in
    case dir of
        North ->
            Player { player | direction = dir, possition = Point x (y - 1) }

        East ->
            Player { player | direction = dir, possition = Point (x + 1) y }

        South ->
            Player { player | direction = dir, possition = Point x (y + 1) }

        West ->
            Player { player | direction = dir, possition = Point (x - 1) y }


playerUpdater : Player -> Action -> Player
playerUpdater ((Player ({ status } as data)) as player) action =
    case action of
        Connected ->
            Player { data | status = Online }

        Disconnected ->
            Player { data | status = Available }

        Move d ->
            movePlayer player d

        _ ->
            player


addIf : Bool -> a -> List a -> List a
addIf cond =
    if cond then
        (::)
    else
        flip always
