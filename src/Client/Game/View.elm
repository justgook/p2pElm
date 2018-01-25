module Client.Game.View exposing (view)

import Client.Game.Main as Game
import Client.Game.StyleDefault exposing (scaled)
import Client.Game.Theme as Theme exposing (Theme, Variation)
import Client.Game.View.Character as Character
import Common.Point exposing (Point(Point))
import Element as Element exposing (..)
import Element.Attributes as Attributes exposing (..)
import Game.Entities as Entities exposing (Entities, Entity(..))


angle : String
angle =
    toString (atan2 4 3)


view : Device -> Game.Model -> Element Theme Variation msg
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
                    , inlineStyle [ ( "transform", "rotateX(" ++ angle ++ "rad) rotateZ(29deg)" ) ]
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


draw : Entity -> Element Theme Variation msg
draw e =
    case e of
        Box p ->
            entity empty Theme.Box p

        Wall p ->
            entity empty Theme.Wall p

        Bomb ->
            empty

        Explosion ->
            empty

        Player { point } ->
            entity Character.view Theme.Player point


entity : Element Theme variation msg -> Theme -> Point -> Element Theme variation msg
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
