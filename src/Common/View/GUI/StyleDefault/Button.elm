module Common.View.GUI.StyleDefault.Button exposing (active, disabled)

import Color exposing (..)
import Style exposing (..)
import Style.Background as Background exposing (..)
import Style.Border as Border
import Style.Color as Color exposing (..)
import Style.Font as Font
import Style.Scale as Scale
import Style.Shadow as Shadow


shadowPack : List (Property class variation)
shadowPack =
    [ Shadow.box
        { offset = ( 0, 4 )
        , size = 0
        , blur = 4
        , color = rgb 36 117 146
        }
    , Shadow.box
        { offset = ( 0, 8 )
        , size = 0
        , blur = 0
        , color = rgb 51 100 136
        }
    , Shadow.box
        { offset = ( 0, 8 )
        , size = 4
        , blur = 8
        , color = rgba 0 0 0 0.7
        }
    ]


active : List (Property class variation)
active =
    [ gradient 0 [ step (rgb 235 79 40), step (rgb 242 181 78) ]
    , hover
        [ gradient 0 [ step (rgb 246 2 1), step (rgb 242 181 78) ]
        ]
    , Shadow.inset
        { offset = ( 0, 0 )
        , size = 0
        , blur = 8
        , color = rgb 240 47 2
        }
    , Shadow.inset
        { offset = ( -4, 4 )
        , size = 0
        , blur = 8
        , color = rgb 253 254 41
        }
    , Shadow.inset
        { offset = ( 2, -2 )
        , size = 0
        , blur = 4
        , color = rgb 240 47 2
        }
    ]
        ++ button


disabled : List (Property class variation)
disabled =
    [ gradient 0 [ step (rgb 81 81 81), step (rgb 181 181 181) ]
    , hover
        [ gradient 0 [ step (rgb 61 61 61), step (rgb 181 181 181) ]
        ]
    , Shadow.inset
        { offset = ( 0, 0 )
        , size = 0
        , blur = 8
        , color = rgb 81 81 81
        }
    , Shadow.inset
        { offset = ( -4, 4 )
        , size = 0
        , blur = 8
        , color = rgb 253 254 253
        }
    , Shadow.inset
        { offset = ( 2, -2 )
        , size = 0
        , blur = 4
        , color = rgb 81 81 81
        }
    ]
        ++ button


button : List (Style.Property class variation)
button =
    [ focus shadowPack
    , text <| rgb 254 253 255
    , Shadow.text
        { offset = ( 0, 2 )

        -- , size = 0
        , blur = 2
        , color = black
        }
    , Border.rounded 16
    ]
        ++ shadowPack
