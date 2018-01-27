module Client.Game.View.Character exposing (view)

import Client.Game.StyleDefault exposing (scaled)
import Client.Game.Theme as Theme exposing (Theme)
import Element as Element exposing (..)
import Element.Attributes as Attributes exposing (..)
import Html
import Html.Attributes as Html


view : Element Theme Never Never
view =
    [ el Theme.PlayerParts [] empty
    , Html.node "div" [ Html.class "foot" ] [ Html.text "" ]
        |> Element.html
    , Html.node "div" [ Html.class "lheand" ] [ Html.text "" ]
        |> Element.html
    , Html.node "div" [ Html.class "body" ] [ Html.text "" ]
        |> Element.html
    , Html.node "div" [ Html.class "rheand" ] [ Html.text "" ]
        |> Element.html
    , Html.node "div" [ Html.class "head" ] [ Html.text "" ]
        |> Element.html
    ]
        |> row Theme.None []


unit : Int -> Length
unit i =
    px (scaled 1 * toFloat i)


unitPX : Int -> String
unitPX i =
    toString (scaled 1 * toFloat i) ++ "px"
