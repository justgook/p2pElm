module Common.View.GUI.StyleDefault.Content exposing (content, page)

import Color exposing (..)
import Style exposing (..)
import Style.Background as Background
import Style.Border as Border
import Style.Color as Color exposing (..)
import Style.Font as Font
import Style.Scale as Scale
import Style.Shadow as Shadow


page : List (Property class variation)
page =
    [ Border.rounded 32
    , background <| rgb 253 245 172

    -- , prop "background" "radial-gradient(rgba(240, 216, 140,0) 0, rgba(240, 216, 140,.15) 30%, rgba(240, 216, 140,.3) 32%, rgba(240, 216, 140,0) 33%) 0 0,\nradial-gradient(rgba(240, 216, 140,0) 0, rgba(240, 216, 140,.1) 11%, rgba(240, 216, 140,.3) 13%, rgba(240, 216, 140,0) 14%) 0 0,\nradial-gradient(rgba(240, 216, 140,0) 0, rgba(240, 216, 140,.2) 17%, rgba(240, 216, 140,.43) 19%, rgba(240, 216, 140,0) 20%) 0 110px,\nradial-gradient(rgba(240, 216, 140,0) 0, rgba(240, 216, 140,.2) 11%, rgba(240, 216, 140,.4) 13%, rgba(240, 216, 140,0) 14%) -130px -170px,\nradial-gradient(rgba(240, 216, 140,0) 0, rgba(240, 216, 140,.2) 11%, rgba(240, 216, 140,.4) 13%, rgba(240, 216, 140,0) 14%) 130px 370px,\nradial-gradient(rgba(240, 216, 140,0) 0, rgba(240, 216, 140,.1) 11%, rgba(240, 216, 140,.2) 13%, rgba(240, 216, 140,0) 14%) 0 0"
    -- , prop "background-size" "470px 470px"
    -- , prop "background-color" "rgb(253, 245, 172)"
    -- , prop "background-image" "radial-gradient(ellipse at center, rgba(253,245,172,1) 0,rgba(154, 81, 36, 1) 150%)"
    --
    , Shadow.inset
        { offset = ( 0, 0 )
        , size = 0
        , blur = 64
        , color = rgba 154 81 36 1
        }
    , Shadow.box
        { offset = ( 0, 4 )
        , size = 2
        , blur = 4
        , color = rgba 0 0 0 0.3
        }
    , Shadow.box
        { offset = ( 0, 8 )
        , size = 8
        , blur = 1
        , color = rgb 154 81 36
        }
    , Shadow.box
        { offset = ( 0, 16 )
        , size = 8
        , blur = 4
        , color = rgba 0 0 0 0.3
        }
    , Shadow.box
        { offset = ( 0, 16 )
        , size = 8
        , blur = 1
        , color = rgb 154 81 36
        }
    ]


content =
    [ background <| rgb 190 142 93
    , Border.rounded 16
    , Shadow.box
        { offset = ( 0, 0 )
        , size = 4
        , blur = 1
        , color = rgb 253 245 172
        }
    , Shadow.box
        { offset = ( 0, 0 )
        , size = 6
        , blur = 1
        , color = rgb 190 142 93
        }
    , Shadow.inset
        { offset = ( 0, 4 )
        , size = 4
        , blur = 8
        , color = rgba 0 0 0 0.3
        }

    -- , Shadow.inset
    --     { offset = ( 2, -2 )
    --     , size = 0
    --     , blur = 4
    --     , color = rgb 0 0 0
    --     }
    ]
