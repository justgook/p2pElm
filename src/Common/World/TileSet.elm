module Common.World.TileSet
    exposing
        ( BombInfo(BombInfo)
        , Item
        , TileSet
        , add
        , allowed
        , bomb
        , collision
        , empty
        , explosion
        , map
        , parse
        , remove
        )

-- import Common.Point.PointDict exposing (PointDict)

import Common.Players.Main exposing (LivePlayersDict)
import Common.Players.Message exposing (PlayerRef)
import Common.Point exposing (Point(Point))
import Common.Point.PointSet as PointSet exposing (PointSet)
import Dict


type alias TileSet =
    --TODO update to quadTree or List List List Item (for faster searchig)
    -- https://gamedevelopment.tutsplus.com/tutorials/quick-tip-use-quadtrees-to-detect-likely-collisions-in-2d-space--gamedev-374
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


exist : Item -> TileSet -> Bool
exist =
    List.member


explosion : Item -> LivePlayersDict -> TileSet -> ( List Item, List Item, List ( Float, Item ), List PlayerRef, List PlayerRef )
explosion bomb livePlayersDict tiles =
    case ( bomb, exist bomb tiles ) of
        ( Bomb (BombInfo { point, owner, size }), True ) ->
            let
                explosionAnimationTime =
                    0.3

                tilesWithoutBomb =
                    --Remove bomb to not colide in recurcion again
                    remove [ bomb ] tiles

                (( drawPoint, explResult ) as explPointstest) =
                    ( PointSet.empty, { remove = [], add = [], bombsUnexploded = [], bombsReturns = [] } )
                        |> explosionCalc point size tilesWithoutBomb

                explPoints =
                    drawPoint |> PointSet.toList |> (::) point

                explItem =
                    Explosion explPoints

                findDeadPlayers =
                    Dict.filter (\player _ -> List.any (\(Point x y) -> player == ( x, y )) explPoints) livePlayersDict

                addItems =
                    [ explItem ] ++ explResult.add

                removeItems =
                    [ bomb ] ++ explResult.remove

                dalayItemsToRemove =
                    [ ( explosionAnimationTime, explItem ) ]

                deadPlayers =
                    Dict.values findDeadPlayers

                bombsReturns =
                    Debug.log "bombsReturns" <| owner :: explResult.bombsReturns
            in
            ( addItems, removeItems, dalayItemsToRemove, deadPlayers, bombsReturns )

        _ ->
            ( [], [], [], [], [] )


explosionCalc : Point -> Int -> TileSet -> ( PointSet, ColideWithItemResult ) -> ( PointSet, ColideWithItemResult )
explosionCalc point_ size_ tiles ( pointset_, colideResult_ ) =
    let
        explosionStream2 =
            explosionStream (collision tiles) point_ size_

        ( pointset, { bombsUnexploded } as colideResult ) =
            explosionStream2 pointset_ explosionStreamUp
                |> (\( points1, item1 ) ->
                        explosionStream2 points1 explosionStreamRight
                            |> (\( points2, item2 ) ->
                                    explosionStream2 points2 explosionStreamDown
                                        |> (\( points3, item3 ) ->
                                                explosionStream2 points3 explosionStreamLeft
                                                    |> (\( points4, item4 ) ->
                                                            ( points4
                                                            , colideResult_
                                                                |> colideWithItem item1
                                                                |> colideWithItem item2
                                                                |> colideWithItem item3
                                                                |> colideWithItem item4
                                                            )
                                                       )
                                           )
                               )
                   )
    in
    case bombsUnexploded of
        [] ->
            ( pointset, colideResult )

        ((BombInfo { point, size, speed, owner }) as info) :: bobsLeft ->
            let
                tilesWithoutBomb =
                    --Remove bomb to not colide in recurcion again
                    -- Don't Like - Creating bomb to remove - refactor to removeFromBombInfo or..
                    remove [ Bomb info ] tiles
            in
            ( PointSet.insert point pointset
            , { colideResult
                | bombsUnexploded = bobsLeft
              }
            )
                |> explosionCalc point size tilesWithoutBomb


explosionStream : (Point -> Maybe Item) -> Point -> Int -> PointSet -> (Point -> Point) -> ( PointSet, Maybe Item )
explosionStream canGoForward point size accumulator updater =
    let
        newPoint =
            updater point
    in
    case ( size > 1, canGoForward newPoint ) of
        ( True, Nothing ) ->
            explosionStream canGoForward newPoint (size - 1) (PointSet.insert newPoint accumulator) updater

        ( _, collisionItem ) ->
            ( accumulator, collisionItem )


type alias ColideWithItemResult =
    { bombsUnexploded : List BombInfo
    , remove : List Item
    , add : List Item
    , bombsReturns : List PlayerRef
    }


colideWithItem : Maybe Item -> ColideWithItemResult -> ColideWithItemResult
colideWithItem item list =
    case item of
        Just ((Bomb ((BombInfo { owner }) as i)) as bomb) ->
            { list
                | bombsUnexploded = i :: list.bombsUnexploded
                , remove = bomb :: list.remove
                , bombsReturns = owner :: list.bombsReturns
            }

        Just ((Box _ None) as box) ->
            { list | remove = box :: list.remove }

        Just ((Box _ bonus) as box) ->
            -- Debug.log
            --     ("Add bonus '"
            --         ++ toString bonus
            --         ++ "' for "
            --     )
            { list | remove = box :: list.remove }

        _ ->
            list


explosionStreamUp : Point -> Point
explosionStreamUp (Point x y) =
    Point x (y - 1)


explosionStreamRight : Point -> Point
explosionStreamRight (Point x y) =
    Point (x + 1) y


explosionStreamDown : Point -> Point
explosionStreamDown (Point x y) =
    Point x (y + 1)


explosionStreamLeft : Point -> Point
explosionStreamLeft (Point x y) =
    Point (x - 1) y


itemByPoint : Point -> TileSet -> List Item
itemByPoint point =
    List.filter (\tile -> position tile == point)


remove : List Item -> TileSet -> TileSet
remove items tiles =
    --TODO need micro optimisation - remove item from list when it is found
    List.filter (\i -> List.member i items |> not) tiles


find : (a -> Bool) -> List a -> Maybe a
find predicate list =
    case list of
        [] ->
            Nothing

        first :: rest ->
            if predicate first then
                Just first
            else
                find predicate rest


collision : List Item -> Point -> Maybe Item
collision tiles point =
    -- TODO  ubdate to itemByPoint detection
    find (\tile -> position tile == point) tiles


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
