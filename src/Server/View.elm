module Server.View exposing (..)

import Html exposing (Html, text, ul, li, div)
-- import List exposing (map)
import Server.Model exposing (Model)
import Html.Attributes exposing (class)
import Common.World.Main as World
import Common.Background as Background
import Common.StatusBar as StatusBar


-- http://elm-lang.org/blog/blazing-fast-html-round-two - ADD lazy (if needed)
view : Model -> Html msg
view model =
  div[class "main-wrapper"]
    [ Background.view
    , World.view model.world
    -- , StatusBar.view model.players
    ]