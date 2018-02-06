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
    Scale.modular 32 1.618


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
    , style Explosion [ pseudo "not(always_true) ~ div.boom" (explosion "not(always_true) ~ div.boom") ]
    , style DeadPlayer
        [ background red
        ]
    , style Player
        [ prop "position" "absolute"
        , prop "transform-style" "preserve-3d"
        , prop "transition-duration" ".25s"
        , prop "transition-property" "top left"
        , prop "transition-timing-function" "cubic-bezier(0.215, 0.61, 0.355, 1)"
        ]
    , style PlayerParts
        [ pseudo "not(always_true) ~ div.head"
            ([ prop "background" "inherit" --background <| rgb 242 215 85 --hsl 61 87.5 60.2
             , translate (unit 0.125) (unit 0.125) (unit 1.5)
             ]
                ++ charBox "not(always_true) ~ div.head" 0.75 0.5 0.75
            )
        , pseudo "not(always_true) ~ div.body"
            ([ prop "background" "inherit"
             , translate (unit 0.25) (unit 0.25) (unit 1)
             ]
                ++ charBox "not(always_true) ~ div.body" 0.5 0.75 0.5
            )
        , pseudo "not(always_true) ~ div.foot"
            ([ prop "background" "inherit"
             , translate (unit (0.25 + 0.125)) (unit 0.25) (unit 0.25)
             ]
                ++ charBox "not(always_true) ~ div.foot" 0.25 0.25 0.5
            )
        , pseudo "not(always_true) ~ div.rheand"
            ([ prop "background" "inherit"
             , translate (unit 0.25) (unit 0.75) (unit 0.75)
             ]
                ++ charBox "not(always_true) ~ div.rheand" 0.25 0.5 0.25
            )
        , pseudo "not(always_true) ~ div.lheand"
            ([ prop "background" "inherit"
             , translate (unit 0.25) (unit 0) (unit 0.75)
             ]
                ++ charBox "not(always_true) ~ div.rheand" 0.25 0.5 0.25
            )
        ]
    ]


explosion : String -> List (Property class variation)
explosion selector =
    let
        base =
            0.5

        height =
            1

        same =
            [ prop "transform-style" "preserve-3d"
            , prop "content" "''"
            , prop "display" "block"
            , prop "position" "absolute"
            , prop "box-sizing" "border-box"
            , prop "width" <| unitPX base
            , prop "height" <| unitPX base
            , prop "border" (unitPX (base / 2) ++ " solid transparent")
            ]
    in
    [ prop "transform-style" "preserve-3d"
    , pseudo (selector ++ ":after")
        (same
            ++ [ prop "border-bottom-color" "rgb(124, 151, 177)"
               , prop "transform" "rotateX(-75.5deg)"
               , prop "transform-origin" "0 100% 0"
               , prop "border-top-width" "0"
               , prop "border-bottom-width" <| unitPX height
               , prop "height" <| unitPX height
               , prop "left" <| unitPX ((1 - base) / 2)
               , prop "bottom" <| unitPX ((1 - base) / 2)
               ]
        )
    , pseudo (selector ++ ":before")
        (same
            ++ [ prop "border-right-color" "rgb(254, 254, 254)"
               , prop "transform" "rotateY(75.5deg)"
               , prop "transform-origin" "100% 0 0"
               , prop "border-left-width" "0"
               , prop "border-right-width" <| unitPX height
               , prop "right" <| unitPX ((1 - base) / 2)
               , prop "top" <| unitPX ((1 - base) / 2)
               ]
        )
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
            [ -- background <| rgb 184 143 56
              prop "background" "inherit"
            , prop "content" "''"
            , prop "position" "absolute"
            ]
    in
    [ prop "transform-origin" "50% 50%"
    , prop "position" "absolute"
    , prop "top" "0"
    , prop "left" "0"
    , prop "transform-style" "preserve-3d"
    , prop "width" (unitPX width)
    , prop "height" (unitPX depth)
    , pseudo (selector ++ ":before") <|
        same
            ++ [ origin 0 0 0
               , prop "transform" ("translateY(" ++ unitPX depth ++ ") rotateX(-90deg) ")
               , prop "width" (unitPX width)
               , prop "height" (unitPX height)
               , prop "background-image" "linear-gradient(rgba(0,0,0,.25), rgba(0,0,0,.25))"
               ]
    , pseudo (selector ++ ":after") <|
        same
            ++ [ origin 0 0 0
               , prop "transform" ("translate(" ++ unitPX width ++ ", " ++ unitPX depth ++ ") rotateZ(-90deg) rotateX(-90deg) ")
               , prop "width" (unitPX depth)
               , prop "height" (unitPX height)
               , prop "background-image" "linear-gradient(rgba(0,0,0,.1), rgba(0,0,0,.1))"
               ]

    -- ++ [  ]
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
