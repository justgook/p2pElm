module Common.Players.Model exposing (Player, Players, empty, updatePlayer, status, add, Status(..))

type Bombs = Bombs Int Int
type Status = Online | NotAvailable | Available
type Player =
  Player
    { status: Status
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

status: Player -> Status
status (Player { status }) = status

add: Players -> Players
add (({p1, p2, p3, p4, p5, p6, p7, p8}) as players) =
  if status p1 == NotAvailable then {players | p1 = (playerUpdater p1 1)}
  else if status p2 == NotAvailable then {players | p2 = (playerUpdater p2 1)}
  else if status p3 == NotAvailable then {players | p3 = (playerUpdater p3 1)}
  else if status p4 == NotAvailable then {players | p4 = (playerUpdater p4 1)}
  else if status p5 == NotAvailable then {players | p5 = (playerUpdater p5 1)}
  else if status p6 == NotAvailable then {players | p6 = (playerUpdater p6 1)}
  else if status p7 == NotAvailable then {players | p7 = (playerUpdater p7 1)}
  else if status p8 == NotAvailable then {players | p8 = (playerUpdater p8 1)}
  else players

empty: Players
empty =
  let
    newPlayer = Player { status = NotAvailable,  bombs = (Bombs 1 1), speed = 10}
  in
  -- Players2
    { p1 = newPlayer
    , p2 = newPlayer
    , p3 = newPlayer
    , p4 = newPlayer
    , p5 = newPlayer
    , p6 = newPlayer
    , p7 = newPlayer
    , p8 = newPlayer
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

playerUpdater: Player -> Int -> Player
playerUpdater ((Player { bombs, speed, status }) as player) action =
  case action of
    0 -> Player { status = Online,  bombs = bombs, speed = speed} --Maybe there is nicer way?
    1 -> Player { status = Available,  bombs = bombs, speed = speed} --Maybe there is nicer way?
    _ -> player
