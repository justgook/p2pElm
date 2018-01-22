module Game.Entities
    exposing
        ( Entities
        , Entity
        , fromString
        , map
        )

import Char
import Common.Point exposing (Point(Point))


type Entity
    = Box Point -- Bonus
    | Wall Point
    | Bomb --BombInfo
    | Explosion --(List Point)
    | Player Point



-- https://gamedevelopment.tutsplus.com/tutorials/quick-tip-use-quadtrees-to-detect-likely-collisions-in-2d-space--gamedev-374
-- http://package.elm-lang.org/packages/elm-lang/trampoline/1.0.1/Trampoline
-- https://github.com/TheSeamau5/elm-quadtree/blob/master/src/QuadTree.elm


type Entities
    = Entities (List Entity)


empty : Entities
empty =
    Entities []


add : List Entity -> Entities -> Entities
add x (Entities xs) =
    Entities (xs ++ x)


remove : List Entity -> Entities -> Entities
remove a b =
    let
        _ =
            Debug.log "implement me Entities::remove" ""
    in
    Entities []


update : Entity -> Entities -> Entities
update a b =
    let
        _ =
            Debug.log "implement me Entities::update" ""
    in
    Entities []


map : (Entity -> a) -> Entities -> List a
map f xs =
    let
        _ =
            Debug.log "Impruve me to real data" "Entities::map"

        (Entities xs_) =
            xs
    in
    List.map f xs_



{-
   based on: <https://github.com/elm-community/list-extra/blob/7.0.1/src/List/Extra.elm>

    indexedFoldl : (Int -> a -> b -> b) -> b -> List a -> b
    indexedFoldl func acc list =
        let
            step : a -> ( Int, b ) -> ( Int, b )
            step x ( index, acc ) =
                ( index + 1, func index x acc )
        in
        Tuple.second (List.foldl step ( 0, acc ) list)
-}


fromString : String -> Entities
fromString data =
    let
        step x ( i, acc ) =
            ( i + 1, (\y d -> parseRow 0 y "0" d) i x acc )
    in
    String.split "|" data
        |> List.foldl step ( 0, empty )
        |> Tuple.second



-------INTERNAL STUFF--------------------------------------------------------------------------------------------


parseRow : Int -> Int -> String -> String -> Entities -> Entities
parseRow x y multiplier data result =
    let
        boxWrapper : Int -> Int -> Entity
        boxWrapper x y =
            Box (Point x y)

        wallWrapper : Int -> Int -> Entity
        wallWrapper x y =
            Wall (Point x y)

        playerWrapper : Int -> Int -> Entity
        playerWrapper x y =
            Player (Point x y)
    in
    case String.uncons data of
        Just ( c, unparsedData ) ->
            (if Char.isDigit c then
                ( x, y, multiplier ++ String.fromChar c, unparsedData, result )
             else if c == '@' then
                appender x y multiplier unparsedData result playerWrapper
             else if c == '#' then
                appender x y multiplier unparsedData result wallWrapper
             else if c == '$' then
                appender x y multiplier unparsedData result boxWrapper
             else
                ( x, y, "0", unparsedData, result )
            )
                |> uncurry5 parseRow

        Nothing ->
            result


appender : Int -> Int -> String -> a -> Entities -> (Int -> Int -> Entity) -> ( Int, Int, String, a, Entities )
appender x y m d r wrapper =
    let
        mult =
            multiplier2int m
    in
    ( x + mult, y, "0", d, add (repeater x y mult wrapper) r )


repeater : Int -> Int -> Int -> (Int -> Int -> Entity) -> List Entity
repeater x y mult wrapper =
    List.range x (mult - 1 + x)
        |> List.map (wrapper y)


multiplier2int : String -> Int
multiplier2int =
    String.toInt
        >> Result.map (max 1)
        >> Result.withDefault 0


uncurry5 : (a -> b -> c -> d -> e -> f) -> ( a, b, c, d, e ) -> f
uncurry5 func ( a, b, c, d, e ) =
    func a b c d e



-- if error then 0; if x <= 0 then 1; if x > 0 then x
-- add
-- type Bonus
--     = BombBonus
--     | Speed
--     | None
-- type BombInfo
--     = BombInfo
--         { point : Point
--         , size : Int
--         , speed : Float
--         , owner : PlayerRef
--         }
