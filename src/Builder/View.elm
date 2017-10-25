module Builder.View exposing (..)

import Html exposing (Html, text, ul, li, div)
-- import List exposing (map)
import Builder.Model exposing (Model)
import Html.Attributes exposing (class)
import Common.Tiles.Tiles as Tiles


-- http://elm-lang.org/blog/blazing-fast-html-round-two - ADD lazy (if needed)
view : Model -> Html msg
view model =
  let
    _ = Debug.log "model in view" model  
  in
    div[class "main-wrapper"]
      [ Tiles.view model.tiles

      ]