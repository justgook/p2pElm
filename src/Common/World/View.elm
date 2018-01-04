module Common.World.View exposing (view)

import Common.Players.Main as Players exposing (Players)
import Common.Players.Message exposing (Direction(..))
import Common.Point exposing (Point(Point))
import Common.World.TileSet as TileSet exposing (Item, TileSet)
import Html exposing (Html, div, li, text, ul)
import Html.Attributes exposing (class, classList, style)
import Html.Lazy exposing (lazy)


view : TileSet -> Players -> Html msg
view tiles players =
    let
        ( w, h ) =
            ( 5, 5 )
    in
    tiles
        |> TileSet.map (plain "box") (plain "cube") bomb explosion
        |> (++) (List.map (lazy (\x -> player x.point x.direction)) <| Players.tiles <| players)
        |> div
            [ class "tiles"
            , style
                [ ( "width", toString w ++ "em" )
                , ( "height", toString h ++ "em" )
                ]
            ]


plain : String -> Point -> Html msg
plain t p =
    div
        [ classList [ ( "tile", True ) ]
        , class t
        , coordinates p
        ]
        []


bomb : Point -> Float -> Html msg
bomb p speed =
    div
        [ class "tile ball"
        , coordinates p
        ]
        []


explosion : List Point -> Html msg
explosion =
    List.map
        (\p ->
            div
                [ class "explosion"
                , coordinates p
                ]
                []
        )
        >> div []


player : Point -> Direction -> Html msg
player p d =
    div
        [ classList [ ( "tile", True ) ]
        , class "player"
        , class <| direction2String d
        , coordinates p
        ]
        [ div [ class "glasses" ] []
        , div [ class "body" ] []
        ]


coordinates : Point -> Html.Attribute msg
coordinates (Point x y) =
    style
        [ ( "top", toString y ++ "em" )
        , ( "left", toString x ++ "em" )
        , ( "z-index", toString (x + y) )
        ]


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
