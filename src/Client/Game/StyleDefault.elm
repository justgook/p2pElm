module Client.Game.StyleDefault exposing (angleX, angleZ, scaled, stylesheet)

-- import Style.Border as Border

import Client.Game.Theme exposing (Theme(..))
import Client.Game.View.Box as Box
import Color exposing (..)
import Style exposing (..)
import Style.Color as Color exposing (..)
import Style.Scale as Scale


scaled : Int -> Float
scaled =
    Scale.modular 64 1.618


angleX : Float
angleX =
    atan2 4 3


angleZ : Float
angleZ =
    degrees 29


stylesheet : List (Style Theme Never)
stylesheet =
    [ style None []
    , style FLoor floor
    , style Box <|
        cube
            ++ Box.style
    , style Wall <|
        cube
            ++ Box.style2
    , style Bomb <| bomb
    , style Player
        [ prop "position" "absolute"
        , prop "transform-style" "preserve-3d"
        ]
    , style PlayerParts
        [ pseudo "not(always_true) ~ div.head"
            ([ background <| rgb 242 215 85
             , translate (unit 0.125) (unit 0.125) (unit 1.5)
             ]
                ++ charBox "not(always_true) ~ div.head" 0.75 0.5 0.75
            )
        , pseudo "not(always_true) ~ div.body"
            ([ background <| rgb 242 215 85
             , translate (unit 0.25) (unit 0.25) (unit 1)
             ]
                ++ charBox "not(always_true) ~ div.body" 0.5 0.75 0.5
            )
        , pseudo "not(always_true) ~ div.foot"
            ([ background <| red
             , translate (unit (0.25 + 0.125)) (unit 0.25) (unit 0.25)
             ]
                ++ charBox "not(always_true) ~ div.foot" 0.25 0.25 0.5
            )
        , pseudo "not(always_true) ~ div.rheand"
            ([ background <| red
             , translate (unit 0.25) (unit 0.75) (unit 0.75)
             ]
                ++ charBox "not(always_true) ~ div.rheand" 0.25 0.5 0.25
            )
        , pseudo "not(always_true) ~ div.lheand"
            ([ background <| red
             , translate (unit 0.25) (unit 0) (unit 0.75)
             ]
                ++ charBox "not(always_true) ~ div.rheand" 0.25 0.5 0.25
            )
        ]
    ]


bomb : List (Property class variation)
bomb =
    [ prop "background-color" "black"
    , prop "background-image" ("radial-gradient(circle at " ++ unitPX 0.5 ++ " " ++ unitPX 1.2 ++ ", rgba(255,255,255, .05), rgba(255,255,255, .1) " ++ unitPX 0.8 ++ ", transparent " ++ unitPX 1 ++ ")")
    , prop "border-radius" "50%"
    , prop "transform" ("rotateZ(" ++ toString -angleZ ++ "rad) rotateX(" ++ toString -angleX ++ "rad) translateY(" ++ unitPX -0.25 ++ ") translateZ(" ++ unitPX 0.5 ++ ")")
    , pseudo "before"
        [ prop "content" "''"
        , prop "position" "absolute"
        , prop "background" "radial-gradient(circle at 50% 120%, rgba(255, 255, 255, 0.7), rgba(255, 255, 255, 0) 70%)"
        , prop "border-radius" "50%"
        , prop "bottom" "2.5%"
        , prop "left" "5%"
        , prop "opacity" "0.6"
        , prop "height" "100%"
        , prop "width" "90%"
        , prop "filter" "blur(.1em)"
        , prop "z-index" "2"
        ]
    , pseudo "after"
        [ prop "width" "100%"
        , prop "height" "100%"
        , prop "content" "''"
        , prop "position" "absolute"
        , prop "top" ".05em"
        , prop "left" ".1em"
        , prop "border-radius" "50%"
        , prop "background" "radial-gradient(circle at 50% 50%, rgba(255, 255, 255, 0.7), rgba(255, 255, 255, 0.4) 14%, rgba(255, 255, 255, 0) 24%)"
        , prop "transform" ("translateX(" ++ unitPX -0.2 ++ ") translateY(" ++ unitPX -0.2 ++ ") skewX(-20deg)")
        , prop "filter" "blur(.03em)"
        ]
    ]


toRgbaString : { alpha : a, blue : b, green : c, red : d } -> String
toRgbaString a =
    "rgba("
        ++ toString a.red
        ++ ","
        ++ toString a.green
        ++ ","
        ++ toString a.blue
        ++ ","
        ++ toString a.alpha
        ++ ")"


unitPX : Float -> String
unitPX i =
    toString (scaled 1 * i) ++ "px"


one : Float
one =
    scaled 1


unit : Float -> Float
unit i =
    scaled 1 * i


cube : List (Property class variation)
cube =
    let
        same =
            [ prop "content" "''"
            , prop "position" "absolute"
            , prop "height" (unitPX 1)
            , prop "width" (unitPX 1)
            ]
    in
    [ prop "transform-origin" "50% 50%"
    , translate 0 0 one
    , prop "top" "0"
    , prop "left" "0"
    , prop "transform-style" "preserve-3d"
    , pseudo "before" <|
        [ origin one one 0
        , prop "transform" "rotateX(90deg)"
        ]
            ++ same
    , pseudo "after" <|
        [ origin one 0 0
        , prop "transform" "rotateY(-90deg)"
        ]
            ++ same
    ]


charBox : String -> Float -> Float -> Float -> List (Property class variation)
charBox selector width height depth =
    let
        same =
            [ background <| rgb 184 143 56
            , prop "content" "''"
            , prop "position" "absolute"
            ]
    in
    [ prop "transform-origin" "50% 50%"
    , prop "position" "absolute"
    , border darkGrey
    , prop "top" "0"
    , prop "left" "0"

    -- , translate 0 0 (unit height)
    , prop "transform-style" "preserve-3d"
    , prop "width" (unitPX width)
    , prop "height" (unitPX depth)
    , pseudo (selector ++ ":before") <|
        [ origin 0 0 0
        , prop "transform" ("translateY(" ++ unitPX depth ++ ") rotateX(-90deg) ")
        , prop "width" (unitPX width)
        , prop "height" (unitPX height)
        ]
            ++ same
    , pseudo (selector ++ ":after") <|
        [ origin 0 0 0
        , prop "transform" ("translate(" ++ unitPX width ++ ", " ++ unitPX depth ++ ") rotateZ(-90deg) rotateX(-90deg) ")
        , prop "width" (unitPX depth)
        , prop "height" (unitPX height)
        ]
            ++ same
            ++ [ background <| rgb 232 178 61 ]
    ]


floor : List (Property class variation)
floor =
    let
        line_color =
            red
                |> toRgb
                |> toRgbaString

        floor_color =
            rgb 234 234 234
    in
    [ prop "background-image" ("linear-gradient(0deg, transparent 24%, " ++ line_color ++ " 25%, " ++ line_color ++ " 26%, transparent 27%, transparent 74%, " ++ line_color ++ " 75%, " ++ line_color ++ " 76%, transparent 77%, transparent), linear-gradient(90deg, transparent 24%, " ++ line_color ++ " 25%, " ++ line_color ++ " 26%, transparent 27%, transparent 74%, " ++ line_color ++ " 75%, " ++ line_color ++ " 76%, transparent 77%, transparent)")
    , prop "background-size" <| unitPX 2 ++ " " ++ unitPX 2
    , prop "background-position" <| unitPX 0.5 ++ " " ++ unitPX 0.5
    , prop "transform-style" "preserve-3d"
    , background <| floor_color
    ]
