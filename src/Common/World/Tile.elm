module Common.World.Tile exposing (Item,  parse, view, allowed, player)

import Html exposing (Html, text, ul, li, div)
import Html.Attributes exposing (class, classList, style)
import List exposing (map)

import Common.Point exposing (Point(Point))
import Common.Players.Model exposing (Direction(..))

type alias Size = Int
type alias Speed = Float

type Item =  Box Point | Wall Point | Bomb Point Size Speed

-- http://www.sokobano.de/wiki/index.php?title=Level_format
-- | Tile   | Char  |
-- |--------|-------|
-- | Floor  | Space |
-- | Player | @     |
-- | Box    | $     |
-- | Wall   | #     |
-- | Bomb   | *     |
allowed : List Char
allowed = ['@','$','#', ' ']

parse : Char -> Int -> Int -> Item
parse kind x y =
  case kind of
    '$' ->  Box (Point x y)
    '#' ->  Wall (Point x y)
    '*' ->  Bomb (Point x y) 5 1
    _ ->  Wall (Point x y)

view : Item -> Html msg
view item =
  case item of
    Box p -> plain "box" p
    Wall p -> plain "cube" p
    Bomb p size speed -> bomb p size speed

direction2String : Direction -> String
direction2String d =
  case d of
    Up -> "up"
    Right -> "right"
    Down -> "down"
    Left -> "left"

player : Point -> Direction -> Html msg
player (Point x y) d =
  div
    [ classList [("tile", True)]
    , class "player"
    , class <| direction2String d
    , style
      [ ("top", (toString y) ++ "em")
      , ("left", (toString x) ++ "em")
      , ("z-index", (toString (x + y)))
      ]
    ] [
      div [class "glasses"][]
    ]

-- TODO Merge those to something more smart
plain : String -> Point -> Html msg
plain t (Point x y) =
   div
    [ classList [("tile", True)]
    , class t
    , style
      [ ("top", (toString y) ++ "em")
      , ("left", (toString x) ++ "em")
      , ("z-index", (toString (x + y)))
      ]
    ] []

-- shadowed: String -> Point -> Html msg
-- shadowed t (Point x y) =
--   div
--     [ class "tile"
--       ,style
--       [ ("top", (toString y) ++ "em")
--       , ("left", (toString x) ++ "em")
--       , ("z-index", (toString (x + y)) ++ "em")
--       ]
--     ]
--     [ div [class "object-shadow"] []
--     , div [class t] []
--     ]

explosion: Direction -> Int -> Int -> Int -> List (Html msg)
explosion dir x y count =
  let
    ss index = case dir of
      Up -> [("top", (toString (y +  index)) ++ "em"), ("left", (toString x) ++ "em")]
      Right -> [("top", (toString y) ++ "em"), ("left", (toString (x + index)) ++ "em")]
      Down -> [("top", (toString (y - index)) ++ "em"), ("left", (toString x) ++ "em")]
      Left -> [("top", (toString y) ++ "em"), ("left", (toString (x - index)) ++ "em")]
  in
    List.range 1 count
    |> map (\index ->
      div
        [ class "tile explosion"
        , style (("z-index", (toString (x + y))) :: ss index)
        ] [])

bomb : Point -> Size -> Speed -> Html msg
bomb (Point x y) size speed =
  let
    a =
      [ explosion Up x y size
      , explosion Right x y size
      , explosion Down x y size
      , explosion Left x y size
      ]
      |> List.concat
      |> List.append [div[class "tile ball"
      , style
          [ ("top", (toString y) ++ "em")
          , ("left", (toString x) ++ "em")
          , ("z-index", (toString (x + y)))
          ]
      ][]]
    -- _ = Debug.log "test" a
  in
    a
    |> div []