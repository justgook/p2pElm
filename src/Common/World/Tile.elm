module Common.World.Tile exposing (BombInfo, Item, allowed, bomb2info, bombInfoOwner, createBomb, info2bomb, parse, player, position, view)

import Common.Players.Main exposing (Direction(..), PlayerRef)
import Common.Point exposing (Point(Point))
import Html exposing (Html, div, li, text, ul)
import Html.Attributes exposing (class, classList, style)
import List exposing (map)


type alias Size =
    Int


type alias Speed =
    Float


type BombInfo
    = BombInfo { point : Point, size : Size, speed : Speed, owner : PlayerRef }


bombInfoOwner : BombInfo -> PlayerRef
bombInfoOwner (BombInfo { owner }) =
    owner


bomb2info : Item -> Maybe BombInfo
bomb2info item =
    case item of
        Bomb bombInfo ->
            Just bombInfo

        _ ->
            Nothing


info2bomb : BombInfo -> Item
info2bomb info =
    Bomb info


type Item
    = Box Point
    | Wall Point
    | Bomb BombInfo
    | Explosion Point Size


position : Item -> Point
position item =
    case item of
        Box p ->
            p

        Wall p ->
            p

        Bomb (BombInfo { point }) ->
            point

        Explosion p _ ->
            p



-- http://www.sokobano.de/wiki/index.php?title=Level_format
-- | Tile   | Char  |
-- |--------|-------|
-- | Floor  | Space |
-- | Player | @     |
-- | Box    | $     |
-- | Wall   | #     |
-- | Bomb   | *     |


allowed : List Char
allowed =
    [ '@', '$', '#', ' ' ]


createBomb : Point -> Size -> Speed -> PlayerRef -> Item
createBomb point size speed owner =
    Bomb (BombInfo { point = point, size = size, speed = speed, owner = owner })


parse : Char -> Int -> Int -> Item
parse kind x y =
    case kind of
        '$' ->
            Box (Point x y)

        '#' ->
            Wall (Point x y)

        -- '*' ->
        --     createBomb (Point x y)
        _ ->
            Wall (Point x y)


view : Item -> Html msg
view item =
    case item of
        Box p ->
            plain "box" p

        Wall p ->
            plain "cube" p

        Bomb (BombInfo { point, size, speed }) ->
            bomb point size speed

        Explosion p size ->
            --TODO update to real
            explosion p size


direction2String : Direction -> String
direction2String d =
    case d of
        North ->
            "up"

        East ->
            "right"

        South ->
            "down"

        West ->
            "left"


player : Point -> Direction -> Html msg
player (Point x y) d =
    div
        [ classList [ ( "tile", True ) ]
        , class "player"
        , class <| direction2String d
        , style
            [ ( "top", toString y ++ "em" )
            , ( "left", toString x ++ "em" )
            , ( "z-index", toString (x + y) )
            ]
        ]
        [ div [ class "glasses" ] []
        , div [ class "body" ] []
        ]



-- TODO Merge those to something more smart


plain : String -> Point -> Html msg
plain t (Point x y) =
    div
        [ classList [ ( "tile", True ) ]
        , class t
        , style
            [ ( "top", toString y ++ "em" )
            , ( "left", toString x ++ "em" )
            , ( "z-index", toString (x + y) )
            ]
        ]
        []



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


explosion : Point -> Size -> Html msg
explosion p s =
    div [] []



-- explosion
-- explosion dir x y count =
--     let
--         ss index =
--             case dir of
--                 North ->
--                     [ ( "top", toString (y + index) ++ "em" ), ( "left", toString x ++ "em" ) ]
--                 East ->
--                     [ ( "top", toString y ++ "em" ), ( "left", toString (x + index) ++ "em" ) ]
--                 South ->
--                     [ ( "top", toString (y - index) ++ "em" ), ( "left", toString x ++ "em" ) ]
--                 West ->
--                     [ ( "top", toString y ++ "em" ), ( "left", toString (x - index) ++ "em" ) ]
--     in
--     List.range 1 count
--         |> map
--             (\index ->
--                 div
--                     [ class "tile explosion"
--                     , style (( "z-index", toString (x + y) ) :: ss index)
--                     ]
--                     []
--             )


bomb : Point -> Size -> Speed -> Html msg
bomb (Point x y) size speed =
    let
        a =
            -- [ explosion North x y size
            -- , explosion East x y size
            -- , explosion South x y size
            -- , explosion West x y size
            -- ]
            []
                |> List.concat
                |> List.append
                    [ div
                        [ class "tile ball"
                        , style
                            [ ( "top", toString y ++ "em" )
                            , ( "left", toString x ++ "em" )
                            , ( "z-index", toString (x + y) )
                            ]
                        ]
                        []
                    ]

        -- _ = Debug.log "test" a
    in
    a
        |> div []
