module Common.World.Main exposing (World, decode, init, view, encode)

import Html exposing (Html, text, ul, li, div)
import List exposing (map, concat, foldr, filterMap, member)
import Html.Attributes exposing (class, classList, style)
import String exposing (split, toInt, toList)

import Common.World.Tile as Tile exposing (Item)
import Common.Players.Model as Players exposing (Players, Direction(Up))
import Common.Point exposing (Point(Point))

-- https://medium.com/elm-shorts/an-intro-to-constructors-in-elm-57af7a72b11e
-- https://learnyouanelm.github.io/pages/08-making-our-own-types-and-typeclasses.html

type alias Width = Int
type alias Height = Int

type World = World Width Height (List Item) Players

init : World
init = World 0 0 [] Players.empty

decode: String -> World
decode tiles =
  let
    (rows, players, y) =  map toList (split "|" tiles)
      |> List.foldl reducer ([], Players.empty, 0)
  in
    World
      ( map List.length rows --TODO fix it - if there is spaces in maximum width row (8# 3#) - width is 12, but result 11
      |> List.maximum
      |> Maybe.withDefault 0
      )
      (List.length rows)
      (concat rows)
      players


encode: World -> String
encode tiles =
  "test"

view : World -> Html msg
view world =
  let
      (w, h) = size world
  in
    tiles world
      |> map Tile.view
      |> List.append (map (\x -> Tile.player x.point x.direction) <| Players.tiles <| players world)
      |> div
        [ class "tiles"
        , style
          [ ("width", toString w ++ "em")
          , ("height", toString h ++ "em")
          ]
        ]

size : World -> (Width, Height)
size (World width height _ _) = (width, height)

tiles: World -> List Item
tiles (World _ _ tiles _) = tiles -- Should include (append) player tiles extracted in parsing

players: World -> Players
players (World _ _ _ players) = players

repeaterWithPlayer: Players -> Int -> Int -> Int -> Char -> (Int, List Item, Players)
repeaterWithPlayer players startX y n itemChar =
  case itemChar of
    ' ' -> (startX + n, [], players)
    '@' ->
        (startX + n, [], Players.add players (Point (startX) y)) -- TODO Parse for multiple players in row (or test test at least for that)
    _ ->
      ( startX + n
      , startX + n - 1
        |> List.range startX
        |> map (\n -> Tile.parse itemChar n y)
      , players
      )

-- https://github.com/elm-lang/core/blob/master/src/Tuple.elm
mapSecond2 : (b1 -> b2) -> (a, b1, c) -> (a, b2, c)
mapSecond2 func (x, y, z) =
  (x, func y, z)

parseRowPlayers : Players -> Int -> String -> List Item -> Int -> List Char -> (List Item, Players)
parseRowPlayers players x multiplier result y data =
  case List.head data of
    Just a ->
      let
        (newX, newResult, newPlayers) =
          if (member a Tile.allowed) then
              case (String.toInt multiplier) of
                Ok 0 -> repeaterWithPlayer players x y 1 a |> mapSecond2 (\x -> result ++ x)
                Ok i -> repeaterWithPlayer players x y i a |> mapSecond2 (\x -> result ++ x)
                Err e -> (x, result, players)
          else
            (x, result, players)
        newMultiplier =
          if (member a Tile.allowed) then
            "0"
          else
            (multiplier ++ String.fromChar a)
      in
        parseRowPlayers newPlayers newX newMultiplier newResult y (List.drop 1 data)
    Nothing -> (result, players)

reducer
    : List Char
    -> ( List (List Item), Players, Int )
    -> ( List (List Item), Players, Int )
reducer item (result, players, y) =
  let
    (row, newPlayers) = parseRowPlayers players 0 "0" [] y item
  in
    (row :: result, newPlayers, y + 1)
