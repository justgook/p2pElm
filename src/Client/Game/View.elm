module Client.Game.View exposing (view)

import Client.Game.Main as Game
import Client.Game.StyleDefault exposing (angleX, angleZ, scaled)
import Client.Game.Theme as Theme exposing (Theme)
import Client.Game.View.Character as Character
import Common.Point exposing (Point(Point))
import Element as Element exposing (..)
import Element.Attributes as Attributes exposing (..)
import Game.Entities as Entities exposing (Entities, Entity(..))
import Html
import Html.Attributes as Html


view : Device -> Game.Model -> Element Theme Never Never
view device ({ entities, size } as model) =
    let
        _ =
            Debug.log "Client.Game.View" "updated"
    in
    modal Theme.None [ width fill, height fill ] <|
        row Theme.None
            [ width fill
            , height fill
            , center
            , verticalCenter
            ]
            [ el
                Theme.None
                [ inlineStyle [ ( "perspective", "1500px" ), ( "perspective-origin", "50% 50%" ) ] ]
                (row Theme.FLoor
                    [ width (unit size.width)
                    , height (unit size.height)
                    , inlineStyle [ ( "transform", "rotateX(" ++ toString angleX ++ "rad) rotateZ(" ++ toString angleZ ++ "rad)" ) ]
                    ]
                    (Entities.map draw entities)
                )
            ]


unit : Int -> Length
unit i =
    px (scaled 1 * toFloat i)


unitPX : Int -> String
unitPX i =
    toString (scaled 1 * toFloat i) ++ "px"



-- http://package.elm-lang.org/packages/elm-lang/lazy/2.0.0/Lazy


draw : Entity -> Element Theme Never Never
draw e =
    case e of
        Box _ p ->
            entity empty Theme.Box p

        Wall _ p ->
            entity empty Theme.Wall p

        Bomb _ { point } ->
            entity empty Theme.Bomb point

        Explosion _ points ->
            explosion Theme.Explosion points

        Player _ { point } ->
            entity Character.view Theme.Player point


explosion : Theme -> List Point -> Element Theme Never Never
explosion class points =
    (el Theme.Explosion [] empty
        :: List.map
            (\(Point x y) ->
                Html.node "div"
                    [ Html.class "boom"
                    , Html.style
                        [ ( "position", "absolute" )
                        , ( "left", unitPX x )
                        , ( "top", unitPX y )
                        , ( "z-index", toString (x + y) )
                        , ( "width", unitPX 1 )
                        , ( "height", unitPX 1 )
                        ]
                    ]
                    [ Html.text "" ]
                    |> Element.html
            )
            points
    )
        |> row Theme.None []


entity : Element Theme Never Never -> Theme -> Point -> Element Theme Never Never
entity child class (Point x y) =
    el class
        [ inlineStyle <|
            [ ( "position", "absolute" )
            , ( "left", unitPX x )
            , ( "top", unitPX y )
            , ( "z-index", toString (x + y) )
            ]
        , width (unit 1)
        , height (unit 1)
        ]
        child
