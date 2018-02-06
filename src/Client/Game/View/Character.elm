module Client.Game.View.Character exposing (dead, view)

import Client.Game.StyleDefault exposing (scaled)
import Client.Game.Theme as Theme exposing (Theme)
import Color exposing (Color)
import Element as Element exposing (..)
import Element.Attributes as Attributes exposing (..)
import Html
import Html.Attributes as Html


view : Color -> Element Theme Never Never
view color =
    let
        { red, green, blue, alpha } =
            Color.toRgb color

        style =
            Html.style [ ( "background", "rgba(" ++ toString red ++ "," ++ toString green ++ "," ++ toString blue ++ "," ++ toString alpha ++ ")" ) ]
    in
    [ el Theme.PlayerParts [] empty
    , Html.node "div" [ Html.class "foot", style ] [ Html.text "" ]
        |> Element.html
    , Html.node "div" [ Html.class "lheand", style ] [ Html.text "" ]
        |> Element.html
    , Html.node "div" [ Html.class "body", style ] [ Html.text "" ]
        |> Element.html
    , Html.node "div" [ Html.class "rheand", style ] [ Html.text "" ]
        |> Element.html
    , Html.node "div" [ Html.class "head", style ] [ Html.text "" ]
        |> Element.html
    ]
        |> row Theme.None []


dead : Element Theme Never Never
dead =
    empty


unit : Int -> Length
unit i =
    px (scaled 1 * toFloat i)


unitPX : Int -> String
unitPX i =
    toString (scaled 1 * toFloat i) ++ "px"
