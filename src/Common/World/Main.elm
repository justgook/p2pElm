module Common.World.Main
    exposing
        ( World
        , addItem
        , bombReturn
        , boom
        , collision
        , decode
        , encode
        , init
        , nextItemId
        , placeBomb
        , players
        , removeItem
        , view
        , walls
        , withUpdatedPlayer
        )

import Common.Players.Main as Players exposing (Direction(..), Player, PlayerRef, Players, playerByRef)
import Common.Point exposing (Point(Point))
import Common.World.Tile as Tile exposing (Item)
import Html exposing (Html, div, li, text, ul)
import Html.Attributes exposing (class, classList, style)
import List exposing ((::), concat, filterMap, foldr, map, member)
import String exposing (split, toInt, toList)


-- https://medium.com/elm-shorts/an-intro-to-constructors-in-elm-57af7a72b11e
-- https://learnyouanelm.github.io/pages/08-making-our-own-types-and-typeclasses.html


type alias Width =
    Int


type alias Height =
    Int


type World
    = World Width Height (List Item) Players


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
        (concat rows)
        players


encode : World -> String
encode tiles =
    "test"


view : World -> Html msg
view world =
    let
        ( w, h ) =
            size world
    in
    walls world
        |> map Tile.view
        |> List.append (map (\x -> Tile.player x.point x.direction) <| Players.tiles <| players world)
        |> div
            [ class "tiles"
            , style
                [ ( "width", toString w ++ "em" )
                , ( "height", toString h ++ "em" )
                ]
            ]


size : World -> ( Width, Height )
size (World width height _ _) =
    ( width, height )


nextItemId : World -> Int
nextItemId (World _ _ items _) =
    List.length items


addItem : World -> Item -> World
addItem ((World w h items p) as world) item =
    World w h (items ++ [ item ]) p


removeItem : World -> Item -> World
removeItem (World w h items p) item =
    World w h (List.filter (\i -> i /= item) items) p


walls : World -> List Item
walls (World _ _ items _) =
    items


players : World -> Players
players (World _ _ _ players) =
    players


setPlayers : Players -> World -> World
setPlayers p (World w h items _) =
    World w h items p


collision : World -> Players.Message -> Bool
collision ((World _ _ _ players) as world) message =
    let
        detection tile =
            let
                ( Point pX pY, Point tX tY ) =
                    ( Players.newPosition players message, Tile.position tile )
            in
            ( pX, pY ) == ( tX, tY )
    in
    walls world
        |> List.any detection



--TODO split file by server / client / common specific stuff


bombReturn : PlayerRef -> World -> World
bombReturn ref ((World _ _ _ players) as world) =
    setPlayers (Players.bombReturn players ref) world


placeBomb : World -> PlayerRef -> Maybe { world : World, bomb : Item, explosionIn : Float }
placeBomb ((World w h items players) as world) ref =
    case Players.placeBomb players ref of
        Nothing ->
            Nothing

        Just ( p, { point, explosionTime, explosionSize } ) ->
            let
                bomb =
                    Tile.createBomb point explosionSize explosionTime ref
            in
            Just
                { world =
                    addItem world bomb
                        |> setPlayers p
                , bomb = bomb
                , explosionIn = explosionTime
                }



-- TODO MOVE TO server sub-file


boom : World -> Tile.BombInfo -> World
boom world info =
    Tile.info2bomb info
        |> removeItem world
        |> bombReturn (Tile.bombInfoOwner info)


withUpdatedPlayer : World -> Players.Message -> World
withUpdatedPlayer (World w h walls players) message =
    World w h walls (Players.updatePlayers players message)


repeaterWithPlayer : Players -> Int -> Int -> Int -> Char -> ( Int, List Item, Players )
repeaterWithPlayer players startX y n itemChar =
    case itemChar of
        ' ' ->
            ( startX + n, [], players )

        '@' ->
            ( startX + n, [], Players.add players (Point startX y) )

        -- TODO Parse for multiple players in row (or test test at least for that)
        _ ->
            ( startX + n
            , startX
                + n
                - 1
                |> List.range startX
                |> map (\n -> Tile.parse itemChar n y)
            , players
            )



-- https://github.com/elm-lang/core/blob/master/src/Tuple.elm


mapSecond2 : (b1 -> b2) -> ( a, b1, c ) -> ( a, b2, c )
mapSecond2 func ( x, y, z ) =
    ( x, func y, z )


parseRowPlayers : Players -> Int -> String -> List Item -> Int -> List Char -> ( List Item, Players )
parseRowPlayers players x multiplier result y data =
    case List.head data of
        Just a ->
            let
                ( newX, newResult, newPlayers ) =
                    if member a Tile.allowed then
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
                    if member a Tile.allowed then
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
