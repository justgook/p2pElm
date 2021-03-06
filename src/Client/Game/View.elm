module Client.Game.View exposing (view)

import Client.Game.Main as Game
import Client.Game.StyleDefault exposing (angleX, angleZ, scaled)
import Client.Game.Theme as Theme exposing (Theme)
import Client.Game.View.Character as Character
import Color exposing (Color)
import Common.Point exposing (Point(Point))
import Dict
import Element as Element exposing (..)
import Element.Attributes as Attributes exposing (..)
import Element.Keyed as Keyed
import Game.Entities as Entities exposing (Entities, Entity(..), Id)
import Html
import Html.Attributes as Html


view : Device -> Game.Model -> Element Theme Never Never
view device ({ entities, size, playerColor } as model) =
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
                (Keyed.row Theme.FLoor
                    [ width (unit size.width)
                    , height (unit size.height)
                    , inlineStyle [ ( "transform", "rotateX(" ++ toString angleX ++ "rad) rotateZ(" ++ toString angleZ ++ "rad)" ) ]
                    ]
                    (Entities.map (draw playerColor) entities)
                )
            ]


unit : Int -> Length
unit i =
    px (scaled 1 * toFloat i)


unitPX : Int -> String
unitPX i =
    toString (scaled 1 * toFloat i) ++ "px"



-- http://package.elm-lang.org/packages/elm-lang/lazy/2.0.0/Lazy


draw : Dict.Dict Id Color -> Entity -> ( String, Element Theme Never Never )
draw playerColor e =
    case e of
        Box n p ->
            ( toString n, entity empty Theme.Box p )

        Wall n p ->
            ( toString n, entity empty Theme.Wall p )

        Bomb n { point } ->
            ( toString n, entity empty Theme.Bomb point )

        Explosion n points ->
            ( toString n, explosion Theme.Explosion points )

        Player n { point, isDead } ->
            if isDead then
                ( toString n, entity empty Theme.DeadPlayer point )
            else
                ( toString n, entity (getColor n playerColor |> Character.view) Theme.Player point )


getColor : Id -> Dict.Dict Id Color -> Color
getColor id colors =
    let
        _ =
            Debug.log "Getting color" <| colors
    in
    Dict.get id colors |> Maybe.withDefault Color.black


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
