module Common.Players.Model exposing (Player(Player), Players, empty, updatePlayer, Status(..))

type Bombs = Bombs Int Int
type Status = Online | NotAvailable | Available
type Player = Player Status Bombs Int


type Player2 =
    Player2
    { status: Status
    , bombs: Bombs
    , speed: Int
    }

playerUpdater2: Player2 -> Int -> Player2
playerUpdater2 ((Player2 { bombs, speed, status }) as player) action =
  case action of
    0 -> Player2 { status = Online,  bombs = bombs, speed = speed} --Maybe there is nicer way?
    1 -> Player2 { status = Available,  bombs = bombs, speed = speed} --Maybe there is nicer way?
    -- 1 -> Player Available bombs speed
    _ -> player

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

updatePlayer : Players -> ( Int, Int ) -> Players
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

playerUpdater: Player -> Int -> Player
playerUpdater ((Player _ bombs speed) as player) action =
  case action of
    0 -> Player Online bombs speed
    1 -> Player Available bombs speed
    _ -> player

empty: Players
empty =
  let
    newPlayer = Player NotAvailable (Bombs 1 1) 10
  in
  { p1 = newPlayer
  , p2 = newPlayer
  , p3 = newPlayer
  , p4 = newPlayer
  , p5 = newPlayer
  , p6 = newPlayer
  , p7 = newPlayer
  , p8 = newPlayer
  }
