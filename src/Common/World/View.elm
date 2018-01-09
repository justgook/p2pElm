module Common.World.View exposing (view)

import Common.Players.Main as Players exposing (Players, Status)
import Common.Players.Message exposing (Direction(..))
import Common.Point exposing (Point(Point))
import Common.World.TileSet as TileSet exposing (Item, TileSet)
import Html exposing (Html, div, li, text, ul)
import Html.Attributes exposing (class, classList, style)
import Html.Keyed exposing (node)


-- import Html.Lazy exposing (lazy, lazy2)
-- else
--     list


view : TileSet -> Players -> Html msg
view tiles players =
    let
        ( w, h ) =
            ( 5, 5 )
    in
    render tiles
        ++ renderPlayers players
        |> node "div"
            [ class "tiles"
            , style
                [ ( "width", toString w ++ "em" )
                , ( "height", toString h ++ "em" )
                ]
            ]


playersFolder : { b | direction : Direction, id : Int, point : Point, status : Status } -> List ( String, Html msg ) -> List ( String, Html msg )
playersFolder p list =
    if p.status == Players.Online then
        player p.point p.direction p.id :: list
    else
        list


renderPlayers : Players -> List ( String, Html msg )
renderPlayers =
    Players.tiles
        >> List.foldr playersFolder []


render : TileSet -> List ( String, Html msg )
render =
    TileSet.map (plain "box") (plain "cube") bomb explosion


plain : String -> Point -> ( String, Html msg )
plain t p =
    ( generateKey p
    , div
        [ classList [ ( "tile", True ) ]
        , class t
        , coordinates p
        ]
        []
    )


bomb : Point -> Float -> ( String, Html msg )
bomb p speed =
    ( generateKey p
    , div
        [ class "tile ball"
        , coordinates p
        ]
        []
    )


explosion : List Point -> ( String, Html msg )
explosion points =
    ( generateExplosionKey points
    , List.map
        (\p ->
            div
                [ class "explosion"
                , coordinates p
                ]
                []
        )
        points
        |> div []
    )


player : Point -> Direction -> Int -> ( String, Html msg )
player p d id =
    ( toString id
    , div
        [ classList [ ( "tile", True ) ]
        , class "player"
        , class <| direction2String d
        , coordinates p
        ]
        [ div [ class "glasses" ] []
        , div [ class "body" ] []
        ]
    )


generateKey : Point -> String
generateKey (Point x y) =
    toString ( x, y )


generateExplosionKey : List Point -> String
generateExplosionKey list =
    (case list of
        [] ->
            Point 0 0

        p :: xs ->
            p
    )
        |> generateKey


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
