module Common.View.GUI.StyleDefault.Header exposing (header)

import Color exposing (..)
import Style exposing (..)
import Style.Background as Background
import Style.Border as Border
import Style.Color as Color exposing (..)
import Style.Font as Font
import Style.Scale as Scale
import Style.Shadow as Shadow


decoration : String -> List (Property class variation)
decoration side =
    [ prop "content" "''"
    , prop "position" "absolute"
    , prop "top" "0"
    , prop "bottom" "0"
    , prop "display" "block"
    , prop "height" "0"
    , prop "box-sizing" "border-box"
    , prop "border" "solid rgb(238, 32, 7)"
    , Shadow.box
        { offset = ( 0, 8 )
        , size = 0
        , blur = 0
        , color = rgb 130 24 16
        }

    --TODO find reason for such ugly numbers
    , prop "border-width" "40.5px"
    , prop ("border-" ++ side ++ "-color") "transparent"
    , prop side "-81px"
    , prop "top" "16px"
    ]


header : List (Property class variation)
header =
    [ background <| rgb 238 32 7
    , text <| rgb 253 253 6
    , Font.center
    , Shadow.text
        { offset = ( 0, 4 )

        -- , size = 0
        , blur = 1
        , color = rgb 130 24 16
        }
    , Shadow.box
        { offset = ( 0, 8 )
        , size = 0
        , blur = 0
        , color = rgb 130 24 16
        }
    , prop "position" "absolute"
    , prop "left" "-80px"
    , pseudo "before" <| decoration "left"
    , pseudo "after" <| decoration "right"
    ]
