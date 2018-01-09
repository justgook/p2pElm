module Common.World.Main
    exposing
        ( World
          -- , bombReturn
        , decode
        , init
        , nextItemId
        , players
        , setPlayers
        , setTiles
        , tiles
        )

-- import Common.Players.Message exposing (Direction(..), PlayerRef)

import Common.Players.Main as Players exposing (Player, Players, playerByRef)
import Common.Point exposing (Point(Point))
import Common.World.TileSet as TileSet exposing (Item, TileSet)
import List exposing (concat, filterMap, foldr, map, member)
import String exposing (split, toInt, toList)


-- https://medium.com/elm-shorts/an-intro-to-constructors-in-elm-57af7a72b11e
-- https://learnyouanelm.github.io/pages/08-making-our-own-types-and-typeclasses.html


type alias Width =
    Int


type alias Height =
    Int


type World
    = World Width Height TileSet Players


init : World
init =
    World 0 0 [] Players.empty


decode : String -> World
decode tiles =
    let
        ( rows, players, y ) =
            map toList (split "|" tiles)
                |> List.foldl reducer ( [], Players.empty, 0 )
    in
    World
        (map List.length rows
            --TODO fix it - if there is spaces in maximum width row (8# 3#) - width is 12, but result 11
            |> List.maximum
            |> Maybe.withDefault 0
        )
        (List.length rows)
        (TileSet.add (concat rows) TileSet.empty)
        players



-- encode : World -> String
-- encode tiles =
--     "test"


size : World -> ( Width, Height )
size (World width height _ _) =
    ( width, height )


nextItemId : World -> Int
nextItemId (World _ _ items _) =
    List.length items


players : World -> Players
players (World _ _ _ players) =
    players


tiles : World -> TileSet
tiles (World _ _ items _) =
    items


setPlayers : Players -> World -> World
setPlayers p (World w h items _) =
    World w h items p


setTiles : TileSet -> World -> World
setTiles tiles (World w h _ p) =
    World w h tiles p



--TODO split file by server / client / common specific stuff
-- bombReturn : PlayerRef -> World -> World
-- bombReturn ref ((World _ _ _ players) as world) =
--     setPlayers (Players.bombReturn players ref) world
-- placeBomb : World -> PlayerRef -> Maybe { world : World, bomb : Item, explosionIn : Float }
-- placeBomb ((World w h items players) as world) ref =
--     case Players.placeBomb players ref of
--         Nothing ->
--             Nothing
--         Just ( p, { point, explosionTime, explosionSize } ) ->
--             let
--                 bomb =
--                     Tile.createBomb point explosionSize explosionTime ref
--             in
--             Just
--                 { world =
--                     addItem bomb world
--                         |> setPlayers p
--                 , bomb = bomb
--                 , explosionIn = explosionTime
--                 }
{--EXPLOSION START--}


explosionStreamUpdater1 : Point -> Point
explosionStreamUpdater1 (Point x y) =
    Point (x + 1) y


explosionStreamUpdater2 : Point -> Point
explosionStreamUpdater2 (Point x y) =
    Point (x - 1) y


explosionStreamUpdater3 : Point -> Point
explosionStreamUpdater3 (Point x y) =
    Point x (y + 1)


explosionStreamUpdater4 : Point -> Point
explosionStreamUpdater4 (Point x y) =
    Point x (y - 1)



-- itemsByPoint
-- delme =
--     Debug.log "delme" <| explosionStream (\(Point x y) -> True) explosionStreamUpdater4 (Point 3 3) 3 []


explosionStream : (Point -> Bool) -> (Point -> Point) -> Point -> Int -> List Point -> List Point
explosionStream canGoForward updater point s accumulator =
    let
        newPoint =
            updater point

        test =
            newPoint
                :: (if s > 1 && canGoForward newPoint then
                        accumulator ++ explosionStream canGoForward updater newPoint (s - 1) accumulator
                    else
                        accumulator
                   )
    in
    test



-- collideWith:TileSet-> Point -> Maybe Item
-- collideWith tiles point =
-- boom2 : TileSet -> Players -> Tile.BombInfo -> ( List Item, List Item, List ( Float, Item ) )
-- boom2 tiles players info =
--     let
--         explosionAnimationTime =
--             0.3
--         itemsToAdd =
--             []
--         itemsToRemove =
--             []
--         dalayItemsToRemove =
--             []
--         -- [(explosionAnimationTime)]
--     in
--     ( itemsToAdd, itemsToRemove, dalayItemsToRemove )
-- explosionFolder : Point -> (Int -> List Item -> List Item)
-- explosionFolder (Point x y) s result =
--     -- TODO update me to recustion
--     -- TODO convert Explosion to Set ...
--     (y + s |> Point x >> flip Tile.createExplosion [])
--         :: (y - s |> Point x >> flip Tile.createExplosion [])
--         :: (x + s |> flip Point y >> flip Tile.createExplosion [])
--         :: (x - s |> flip Point y >> flip Tile.createExplosion [])
--         :: result
-- boom : World -> Tile.BombInfo -> World
-- boom world info =
--     -- let
--     --     expls =
--     --         Tile.bombInfoSize info
--     --             |> List.range 1
--     --             |> List.foldr (Tile.bombPossition info |> explosionFolder) []
--     -- in
--     -- Tile.info2bomb info
--     --     -- |> removeItem world
--     --     |> addItems expls
--     --     |> bombReturn (Tile.bombInfoOwner info)
--     world
{--EXPLOSION END--}


repeaterWithPlayer : Players -> Int -> Int -> Int -> Char -> ( Int, TileSet, Players )
repeaterWithPlayer players startX y n itemChar =
    case itemChar of
        ' ' ->
            ( startX + n, [], players )

        '@' ->
            ( startX + n, [], Players.add (Point startX y) players )

        -- TODO Parse for multiple players in row (or test test at least for that)
        _ ->
            ( startX + n
            , startX
                + n
                - 1
                |> List.range startX
                |> map (\n -> TileSet.parse itemChar n y)
            , players
            )



-- https://github.com/elm-lang/core/blob/master/src/Tuple.elm


mapSecond2 : (b1 -> b2) -> ( a, b1, c ) -> ( a, b2, c )
mapSecond2 func ( x, y, z ) =
    ( x, func y, z )



-- allowedCharacters : List Char
-- allowedCharacters =
--     [ '@', '$', '#', ' ' ]


parseRowPlayers : Players -> Int -> String -> List Item -> Int -> List Char -> ( List Item, Players )
parseRowPlayers players x multiplier result y data =
    case List.head data of
        Just a ->
            let
                ( newX, newResult, newPlayers ) =
                    if member a TileSet.allowed then
                        case String.toInt multiplier of
                            Ok 0 ->
                                repeaterWithPlayer players x y 1 a |> mapSecond2 (\x -> result ++ x)

                            Ok i ->
                                repeaterWithPlayer players x y i a |> mapSecond2 (\x -> result ++ x)

                            Err e ->
                                ( x, result, players )
                    else
                        ( x, result, players )

                newMultiplier =
                    if member a TileSet.allowed then
                        "0"
                    else
                        multiplier ++ String.fromChar a
            in
            parseRowPlayers newPlayers newX newMultiplier newResult y (List.drop 1 data)

        Nothing ->
            ( result, players )


reducer :
    List Char
    -> ( List (List Item), Players, Int )
    -> ( List (List Item), Players, Int )
reducer item ( result, players, y ) =
    let
        ( row, newPlayers ) =
            parseRowPlayers players 0 "0" [] y item
    in
    ( row :: result, newPlayers, y + 1 )
