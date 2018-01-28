module Game.Entities
    exposing
        ( Entities(Entities)
        , Entity(..)
        , Id
        , PlayerStatus(..)
        , add
        , collision
        , empty
        , explode
        , fromString
        , get
        , id
        , map
        , partition
        , position
        , remove
        , setPosition
        , update
        )

import Char
import Common.Point exposing (Point(Point))
import Common.Point.PointSet as PointSet exposing (fromList, toList)
import Dict exposing (Dict)


type alias Id =
    Int


type Entity
    = Box Id Point -- Bonus
    | Wall Id Point
    | Bomb Id { size : Int, author : Id, point : Point }
    | Explosion Id (List Point)
    | Player
        Id
        { status : PlayerStatus
        , point : Point
        , bombsLeft : Int
        , explosionTime : Float
        , explosionSize : Int
        , speed : Int
        }


type PlayerStatus
    = PlayerOnline
    | PlayerDead



-- https://gamedevelopment.tutsplus.com/tutorials/quick-tip-use-quadtrees-to-detect-likely-collisions-in-2d-space--gamedev-374
-- http://package.elm-lang.org/packages/elm-lang/trampoline/1.0.1/Trampoline
-- https://github.com/TheSeamau5/elm-quadtree/blob/master/src/QuadTree.elm


type Entities
    = Entities (Dict Id Entity)



{- ( updateAddItems, removeIds, removeInTimItems ) -}


explode bombId entities =
    let
        ( explPoints, items2remove, deadPlayers, rest ) =
            bombRecursion [ bombId ] entities ( [], [], [], [] )
    in
    ( explPoints, items2remove, deadPlayers )


bombRecursion : List Id -> Entities -> ( List Point, List Id, List Id, List Id ) -> ( List Point, List Id, List Id, List Id )
bombRecursion bombIds entities acc =
    case bombIds of
        [] ->
            acc

        bombId :: bobsLeft ->
            case get bombId entities of
                Just (Bomb _ { point, size }) ->
                    let
                        goUp (Point x y) d =
                            Point x (y - d)

                        goRight (Point x y) d =
                            Point (x + d) y

                        goDown (Point x y) d =
                            Point x (y + d)

                        goLeft (Point x y) d =
                            Point (x - d) y

                        ( pointsUp, colidedItemsUp ) =
                            List.range 1 size
                                |> explodeFoldl (folding goUp entities point) ( [], Nothing )
                                |> Tuple.mapSecond (Maybe.map List.singleton >> Maybe.withDefault [])

                        ( pointsRight, colidedItemsRight ) =
                            List.range 1 size
                                |> explodeFoldl (folding goRight entities point) ( [], Nothing )
                                |> Tuple.mapSecond (Maybe.map List.singleton >> Maybe.withDefault [])

                        ( pointsDown, colidedItemsDown ) =
                            List.range 1 size
                                |> explodeFoldl (folding goDown entities point) ( [], Nothing )
                                |> Tuple.mapSecond (Maybe.map List.singleton >> Maybe.withDefault [])

                        ( pointsLeft, colidedItemsLeft ) =
                            List.range 1 size
                                |> explodeFoldl (folding goLeft entities point) ( [], Nothing )
                                |> Tuple.mapSecond (Maybe.map List.singleton >> Maybe.withDefault [])

                        ( colidedIds, bombsIds, deadPlayers ) =
                            colidedItemsUp
                                ++ colidedItemsRight
                                ++ colidedItemsDown
                                ++ colidedItemsLeft
                                |> List.foldl outputFilter ( [], [], [] )

                        explosionPoints =
                            [ point ]
                                ++ pointsUp
                                ++ pointsRight
                                ++ pointsDown
                                ++ pointsLeft
                                |> PointSet.fromList
                                |> PointSet.toList

                        ( first, second, third, rest ) =
                            acc

                        resultbombsIds =
                            bombsIds ++ bobsLeft

                        result =
                            ( explosionPoints ++ first
                            , bombId :: colidedIds ++ second
                            , deadPlayers ++ third
                            , resultbombsIds
                            )
                    in
                    bombRecursion resultbombsIds (remove [ bombId ] entities) result

                _ ->
                    acc


outputFilter : Entity -> ( List Id, List Id, List Id ) -> ( List Id, List Id, List Id )
outputFilter x (( xs1, xs2, xs3 ) as xs) =
    case x of
        Bomb n _ ->
            ( xs1, n :: xs2, xs3 )

        Box n _ ->
            ( n :: xs1, xs2, xs3 )

        Player n data ->
            ( xs1, xs2, n :: xs3 )

        _ ->
            xs


folding : (a -> b -> Point) -> Entities -> a -> b -> ( List Point, c ) -> ( List Point, Maybe Entity )
folding pointUpdater entities point d ( xs, found ) =
    let
        newPoint =
            pointUpdater point d
    in
    ( newPoint :: xs, collision newPoint entities )


explodeFoldl : (b -> ( List a, Maybe a1 ) -> ( List a, Maybe a1 )) -> ( List a, Maybe a1 ) -> List b -> ( List a, Maybe a1 )
explodeFoldl func ( acc, found ) list =
    case ( list, found ) of
        ( x :: xs, Nothing ) ->
            explodeFoldl func (func x ( acc, found )) xs

        _ ->
            ( List.drop 1 acc, found )


explodePoints : Point -> Int -> List Point
explodePoints (Point x y) distance =
    [ Point (x + distance) y
    , Point x (y + distance)
    , Point (x - distance) y
    , Point x (y - distance)
    ]


collision : Point -> Entities -> Maybe Entity
collision point (Entities xs) =
    --TODO UPDATE to somethink faster Dict Point:[id]
    getFirst (\e -> position e == point) (Dict.values xs)


getFirst : (a -> Bool) -> List a -> Maybe a
getFirst func list =
    case list of
        x :: xs ->
            if func x then
                Just x
            else
                getFirst func xs

        [] ->
            Nothing


empty : Entities
empty =
    Entities Dict.empty


add : List Entity -> Entities -> Entities
add x (Entities xs) =
    List.foldl (\i r -> Dict.insert (id i) i r) xs x
        |> Entities


remove : List Id -> Entities -> Entities
remove x (Entities xs) =
    List.foldl (\i r -> Dict.remove i r) xs x
        |> Entities



-- Dict.remove


get : Id -> Entities -> Maybe Entity
get n (Entities xs) =
    Dict.get n xs


update : List Entity -> Entities -> Entities
update =
    add


partition : (Id -> Entity -> Bool) -> Entities -> ( List Entity, Entities )
partition fun (Entities xs) =
    Dict.partition fun xs
        |> Tuple.mapFirst Dict.values
        |> Tuple.mapSecond Entities


map : (Entity -> a) -> Entities -> List a
map f xs =
    let
        (Entities xs_) =
            xs
    in
    Dict.values xs_
        |> List.map f


id : Entity -> Id
id item =
    case item of
        Box i _ ->
            i

        Wall i p ->
            i

        Bomb i p ->
            i

        Explosion i _ ->
            i

        Player i { point } ->
            i


position : Entity -> Point
position item =
    case item of
        Box _ point ->
            point

        Wall _ point ->
            point

        Bomb _ { point } ->
            point

        Explosion _ lp ->
            case lp of
                p :: _ ->
                    p

                [] ->
                    Point 0 0

        Player _ { point } ->
            point


setPosition : Point -> Entity -> Entity
setPosition point item =
    case item of
        Box n p ->
            Box n point

        Wall n p ->
            Wall n point

        Bomb n data ->
            Bomb n { data | point = point }

        Explosion n ps ->
            Explosion n (point :: ps)

        Player n data ->
            Player n { data | point = point }



{-
   based on: <https://github.com/elm-community/list-extra/blob/7.0.1/src/List/Extra.elm>
-}
------------------------------------INTERNAL STUFF--------------------------------------
-- indexedFoldl : (Int -> a -> b -> b) -> b -> List a -> b
-- indexedFoldl func acc list =
--     let
--         step : a -> ( Int, b ) -> ( Int, b )
--         step x ( index, acc ) =
--             ( index + 1, func index x acc )
--     in
--     Tuple.second (List.foldl step ( 0, acc ) list)
-- fromString : String -> Entities


fromString : String -> ( Entities, Id )
fromString data =
    let
        step x ( i, acc, id_ ) =
            let
                ( emm, newId ) =
                    (\y d -> parseRow id_ 0 y "0" d) i x acc
            in
            ( i + 1, emm, newId )

        ( _, result, lastId ) =
            String.split "|" data
                |> List.foldl step ( 0, empty, 0 )
    in
    ( result, lastId )



--     |> indexedFoldl (\y d -> parseRow 0 y "0" d) empty
-------INTERNAL STUFF--------------------------------------------------------------------------------------------


parseRow : Id -> Int -> Int -> String -> String -> Entities -> ( Entities, Id )
parseRow id_ x y multiplier data result =
    let
        boxWrapper : Int -> Int -> Int -> Entity
        boxWrapper n x y =
            Box n (Point x y)

        wallWrapper : Int -> Int -> Int -> Entity
        wallWrapper n x y =
            Wall n (Point x y)

        playerWrapper : Int -> Int -> Int -> Entity
        playerWrapper n x y =
            Player n
                { status = PlayerOnline
                , point = Point x y
                , speed = 1
                , bombsLeft = 3
                , explosionTime = 2
                , explosionSize = 10
                }
    in
    case String.uncons data of
        Just ( c, unparsedData ) ->
            (if Char.isDigit c then
                ( id_, x, y, multiplier ++ String.fromChar c, unparsedData, result )
             else if c == '@' then
                appender id_ x y multiplier unparsedData result playerWrapper
             else if c == '#' then
                appender id_ x y multiplier unparsedData result wallWrapper
             else if c == '$' then
                appender id_ x y multiplier unparsedData result boxWrapper
             else
                ( id_, x + multiplier2int multiplier, y, "0", unparsedData, result )
            )
                |> uncurry6 parseRow

        Nothing ->
            ( result, id_ )


appender : Id -> Int -> Int -> String -> String -> Entities -> (Id -> Int -> Int -> Entity) -> ( Id, Int, Int, String, String, Entities )
appender id_ x y m d r wrapper =
    let
        mult =
            multiplier2int m

        ( newId, entities ) =
            repeater id_ x y mult wrapper
    in
    ( newId, x + mult, y, "0", d, add entities r )


repeater : Int -> Int -> Int -> Int -> (Int -> Int -> Int -> Entity) -> ( Id, List Entity )
repeater id_ x y mult wrapper =
    let
        func n x acc =
            wrapper n x y :: acc

        step x ( index, acc ) =
            ( index + 1, func index x acc )
    in
    List.range x (mult - 1 + x)
        |> List.foldl step ( id_, [] )



--List.map (flip (wrapper id_) y)


multiplier2int : String -> Int
multiplier2int =
    -- if error then 0; if x <= 0 then 1; if x > 0 then x
    String.toInt
        >> Result.map (max 1)
        >> Result.withDefault 0


uncurry6 : (a -> b -> c -> d -> e -> f -> g) -> ( a, b, c, d, e, f ) -> g
uncurry6 func ( a, b, c, d, e, f ) =
    func a b c d e f
