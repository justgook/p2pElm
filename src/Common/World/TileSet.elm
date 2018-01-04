module Common.World.TileSet
    exposing
        ( BombInfo(BombInfo)
        , Item
        , TileSet
        , add
        , bomb
        , collision
        , empty
        , explosion
        , map
        , parse
        , remove
        )

import Common.Players.Main exposing (LivePlayersDict)
import Common.Players.Message exposing (PlayerRef)
import Common.Point exposing (Point(Point))


type alias TileSet =
    List Item


type Bonus
    = BombBonus
    | Speed
    | None


type Item
    = Box Point Bonus
    | Wall Point
    | Bomb BombInfo
    | Explosion (List Point)


type BombInfo
    = BombInfo
        { point : Point
        , size : Int
        , speed : Float
        , owner : PlayerRef
        }


empty : TileSet
empty =
    []


add : List Item -> TileSet -> TileSet
add newItems tiles =
    tiles ++ newItems


bomb : BombInfo -> Item
bomb info =
    Bomb info


explosion : Item -> LivePlayersDict -> TileSet -> ( List Item, List Item, List ( Float, Item ), List PlayerRef, List PlayerRef )
explosion bomb livePlayersDict tiles =
    case bomb of
        Bomb (BombInfo { point, owner, size }) ->
            let
                explosionAnimationTime =
                    0.3

                explosionStream2 =
                    explosionStream (\(Point x y) -> True) point size []

                explItem =
                    [ point ]
                        ++ explosionStream2 (\(Point x y) -> Point (x - 1) y)
                        ++ explosionStream2 (\(Point x y) -> Point (x + 1) y)
                        ++ explosionStream2 (\(Point x y) -> Point x (y - 1))
                        ++ explosionStream2 (\(Point x y) -> Point x (y + 1))
                        |> Explosion

                addItems =
                    [ explItem ]

                removeItems =
                    [ bomb ]

                dalayItemsToRemove =
                    [ ( explosionAnimationTime, explItem ) ]

                deadPlayers =
                    []

                bombsReturns =
                    [ owner ]
            in
            ( addItems, removeItems, dalayItemsToRemove, deadPlayers, bombsReturns )

        _ ->
            ( [], [], [], [], [] )


explosionStream : (Point -> Bool) -> Point -> Int -> List Point -> (Point -> Point) -> List Point
explosionStream canGoForward point size accumulator updater =
    let
        newPoint =
            updater point

        test =
            newPoint
                :: (if size > 1 && canGoForward newPoint then
                        accumulator ++ explosionStream canGoForward newPoint (size - 1) accumulator updater
                    else
                        accumulator
                   )
    in
    test



-- explosion : Int -> Point -> TileSet -> Item
-- explosion s p t =
--     Explosion [ p ]


remove : List Item -> TileSet -> TileSet
remove items tiles =
    --TODO micro optimisation - remove item from list when it is found
    List.filter (\i -> List.member i items |> not) tiles


collision : TileSet -> Point -> Bool
collision tiles point =
    let
        detection tile =
            let
                ( Point pX pY, Point tX tY ) =
                    ( point, position tile )
            in
            ( pX, pY ) == ( tX, tY )
    in
    tiles
        |> List.any detection


position : Item -> Point
position item =
    case item of
        Box p _ ->
            p

        Wall p ->
            p

        Bomb (BombInfo { point }) ->
            point

        Explosion lp ->
            case lp of
                p :: _ ->
                    p

                [] ->
                    Point 0 0


map : (Point -> a) -> (Point -> a) -> (Point -> Float -> a) -> (List Point -> a) -> TileSet -> List a
map boxFunc wallFunc bombFunc explFunc tiles =
    tiles
        |> List.map
            (\item ->
                case item of
                    Box p _ ->
                        boxFunc p

                    Wall p ->
                        wallFunc p

                    Bomb (BombInfo { point, speed }) ->
                        bombFunc point speed

                    Explosion l ->
                        explFunc l
            )


allowed : List Char
allowed =
    [ '@', '$', '#', ' ', 'b' ]


parse : Char -> Int -> Int -> Item
parse kind x y =
    case kind of
        '$' ->
            Box (Point x y) None

        'b' ->
            Box (Point x y) BombBonus

        '#' ->
            Wall (Point x y)

        _ ->
            Wall (Point x y)
