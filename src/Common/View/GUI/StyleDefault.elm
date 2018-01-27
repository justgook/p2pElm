module Common.View.GUI.StyleDefault exposing (scaled, stylesheet)

-- import Style.Background as Background
-- import Style.Border as Border
-- import Style.Font as Font
-- import Style.Background as Background exposing (step)
-- import Style.Border as Border

import Color exposing (..)
import Common.View.GUI.StyleDefault.Button as Button
import Common.View.GUI.StyleDefault.Content exposing (content, page)
import Common.View.GUI.StyleDefault.Header exposing (header)
import Common.View.GUI.Theme exposing (ButtonStyles(..), Theme(..), Variation)
import Style exposing (..)
import Style.Color as Color exposing (..)
import Style.Font as Font
import Style.Scale as Scale
import Style.Shadow as Shadow
import Style.Transition as Transition exposing (transitions)
import Time exposing (second)


-- import Style.Shadow as Shadow


scaled : Int -> Float
scaled =
    Scale.modular 16 1.618


delme : List (Property class Never)
delme =
    [ Font.typeface [ Font.font "Seymour One" ]
    , Font.size 32
    , Font.letterSpacing -7
    ]


contentResult : List (Property class Never)
contentResult =
    content
        ++ delme
        ++ [ text white
           , Font.size 16
           , Font.letterSpacing -0.5
           , Shadow.text
                { offset = ( 0, 1 )
                , blur = 1
                , color = black
                }
           ]


stylesheet : List (Style Theme Never)
stylesheet =
    [ Style.importUrl "https://fonts.googleapis.com/css?family=Seymour+One"
    , Style.style Header
        (header
            ++ delme
            ++ [ Font.size <| scaled 4 ]
        )
    , Style.style Content contentResult
    , Style.style Footer []
    , Style.style (Button Active) (Button.active ++ delme)
    , Style.style (Button Disabled) (Button.disabled ++ delme)
    , Style.style None []
    , Style.style Page page
    , Style.style Loading <| delme ++ [ Font.size <| scaled 4 ]
    , Style.style GridItem contentResult
    , Style.style SelectListItem
        ([ Style.cursor "pointer"
         , hover
            [ background <| rgb 253 253 6
            ]
         , transitions
            [ { delay = 0
              , duration = second * 0.13
              , easing = "ease"
              , props = [ "background" ]
              }
            ]
         ]
            ++ contentResult
        )
    ]
