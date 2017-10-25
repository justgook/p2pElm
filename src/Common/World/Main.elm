module Common.World.Main exposing (World, decode, init, view, encode)

import Html exposing (Html, text, ul, li, div)
import List exposing (map, concat, foldr, filterMap, member)
import Html.Attributes exposing (class, classList, style)
import String exposing (split, toInt, toList)
-- import Char exposing (isDigit)

import Common.World.Tile as Tile exposing (Item, allowed)
import Common.Players.Model as Players exposing (Players)
-- import Common.Point exposing (Point(Point))

-- https://medium.com/elm-shorts/an-intro-to-constructors-in-elm-57af7a72b11e
-- https://learnyouanelm.github.io/pages/08-making-our-own-types-and-typeclasses.html

type alias Width = Int
type alias Height = Int

type World = World Width Height (List Item) Players

encode: World -> String
encode tiles =
  "test"

-- repeaterWithPlayer: Players-> Int -> Int -> Int -> Char -> (Int, List Item, Players)
-- repeaterWithPlayer players startX y n itemChar =
--   case itemChar of
--     ' ' -> (startX + n, [], players)
--     _ ->
--       ( startX + n
--       , startX + n - 1
--         |> List.range startX
--         |> map (\n -> Tile.parse itemChar n y)
--       , players
--       )

repeater: Int -> Int -> Int -> Char -> (Int, List Item)
repeater startX y n itemChar =
  case itemChar of
    ' ' -> (startX + n, [])
    _ ->
      ( startX + n
      , startX + n - 1
        |> List.range startX
        |> map (\n -> Tile.parse itemChar n y)
      )

-- TODO extract players as separate part
parseRow : Int -> String -> List Item -> Int -> List Char -> List Item
parseRow x multiplier result y data =
  case List.head data of
    Just a ->
      let
        (newX, newResult) =
          if (member a allowed) then
              case (String.toInt multiplier) of
                Ok 0 -> repeater x y 1 a |> Tuple.mapSecond (\x -> result ++ x)
                Ok i -> repeater x y i a |> Tuple.mapSecond (\x -> result ++ x)
                Err e -> (x, result)
          else
            (x, result)
        newMultiplier =
          if (member a allowed) then
            "0"
          else
            (multiplier ++ String.fromChar a)
      in
        parseRow newX newMultiplier newResult y (List.drop 1 data)
    Nothing -> result

init : World
init = World 0 0 [] Players.empty

decode: String -> World
decode tiles =
  let
    rows = map toList (split "|" tiles)
      |> List.indexedMap (parseRow 0 "0" [])
  in
    World
      ( map List.length rows --TODO fix it - if there is spaces in maximum width row (8# 3#) - width is 12, but result 11
      |> List.maximum
      |> Maybe.withDefault 0
      )
      (List.length rows)
      (concat rows)
      Players.empty

getSize : World -> (Width, Height)
getSize (World width height _ _) = (width, height)

getTiles: World -> List Item
getTiles (World _ _ tiles _) = tiles -- Should include (append) player tiles extracted in parsing

getPlayers: World -> Players
getPlayers (World _ _ _ players) = players

-- getPlayers: Tiles -> Players
-- getPlayers tiles =
--   Players

view : World -> Html msg
view world =
  let
      tiles = getTiles world
      (w, h) = getSize world
  in
    tiles
      |> map Tile.view
      |> div
        [ class "tiles"
        , style
          [ ("width", toString w ++ "em")
          , ("height", toString h ++ "em")
          ]
        ]
