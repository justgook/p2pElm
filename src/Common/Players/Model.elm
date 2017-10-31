module Common.Players.Model exposing (Player, Players, empty, updatePlayer, status, add, tiles, Status(..), Direction(..))
import Common.Point exposing (Point(Point))

type Direction = Up | Right | Down | Left

type Bombs = Bombs Int Int
type Status = Online | NotAvailable | Available

type Player =
  Player
    { possition: Point
    , status: Status
    , bombs: Bombs
    , speed: Int
    }

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

add: Players -> Point -> Players
add (({p1, p2, p3, p4, p5, p6, p7, p8}) as players) point =
  if statusNotAvailable p1 then {players | p1 = createPlayer p1 point}
  else if statusNotAvailable p2 then {players | p2 = createPlayer p2 point}
  else if statusNotAvailable p3 then {players | p3 = createPlayer p3 point}
  else if statusNotAvailable p4 then {players | p4 = createPlayer p4 point}
  else if statusNotAvailable p5 then {players | p5 = createPlayer p5 point}
  else if statusNotAvailable p6 then {players | p6 = createPlayer p6 point}
  else if statusNotAvailable p7 then {players | p7 = createPlayer p7 point}
  else if statusNotAvailable p8 then {players | p8 = createPlayer p8 point}
  else players

status: Player -> Status
status (Player { status }) = status

statusNotAvailable: Player -> Bool
statusNotAvailable (Player { status }) = status == NotAvailable

tiles: Players -> List {point: Point, direction: Direction, id: number}
tiles (({p1, p2, p3, p4, p5, p6, p7, p8}) as players) =
  tilesAppender 1 p1
  <| tilesAppender 2 p2
  <| tilesAppender 3 p3
  <| tilesAppender 4 p4
  <| tilesAppender 5 p5
  <| tilesAppender 6 p6
  <| tilesAppender 7 p7
  <| tilesAppender 8 p8 []

empty: Players
empty =
  let
    player = Player { status = NotAvailable,  bombs = (Bombs 1 1), speed = 10 , possition = Point 0 0}
  in
  -- Players2
    { p1 = player
    , p2 = player
    , p3 = player
    , p4 = player
    , p5 = player
    , p6 = player
    , p7 = player
    , p8 = player
    }

tilesAppender : number -> Player -> List { direction : Direction, id : number, point : Point } -> List { direction : Direction, id : number, point : Point }
tilesAppender id player tiles =
  if not (statusNotAvailable player) then
    {point = possition player, direction = Up, id = id} :: tiles
  else tiles

possition : Player -> Point
possition (Player { possition }) = possition

createPlayer : Player -> Point -> Player
createPlayer (Player { bombs, speed }) p =
      Player
      { status = Available
      , bombs = bombs
      , speed = speed
      , possition = p
      }

updatePlayer: Players -> ( Int, Int ) -> Players
updatePlayer players (index, action) =
  let update = \p -> playerUpdater (p players) action
  in case index of
    0 -> {players | p1 = update .p1}
    1 -> {players | p2 = update .p2}
    2 -> {players | p3 = update .p3}
    3 -> {players | p4 = update .p4}
    4 -> {players | p5 = update .p5}
    5 -> {players | p6 = update .p6}
    6 -> {players | p7 = update .p7}
    7 -> {players | p8 = update .p8}
    _ -> players



{-
  Connected: 0,
  Disconnected: 1,
  Up: 2,
  Right: 3,
  Down: 4,
  Left: 5,
  Bomb: 6,
  Error: 7,
-}

playerUpdater: Player -> Int -> Player
playerUpdater ((Player { bombs, speed, status, possition }) as player) action =
  case action of
    0 -> Player { status = Online,  bombs = bombs, speed = speed, possition = possition} --Maybe there is nicer way?
    1 -> Player { status = Available,  bombs = bombs, speed = speed, possition = possition} --Maybe there is nicer way?
    -- 2 -> Player { status = Available,  bombs = bombs, speed = speed, possition = possition} --Maybe there is nicer way?
    _ -> player
