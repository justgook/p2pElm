module Client.Game.Main exposing (Model, model, update)

import Client.Game.Message exposing (Message)
import Client.Message as MainMessage
import Color exposing (Color)
import Common.Point exposing (Point(Point))
import Dict exposing (Dict)
import Game.Entities as Entities exposing (Entities, Id)
import Process
import Shared.Protocol as Protocol
import Task
import Time


type alias FloorSize =
    { width : Int, height : Int }


type alias Model =
    { entities : Entities
    , size : FloorSize
    , playerColor : Dict Id Color
    }


colorPalette : Int -> Color
colorPalette index =
    let
        colors =
            [ Color.rgb 244 67 54 -- "#F44336"
            , Color.rgb 233 30 99 -- "#E91E63"
            , Color.rgb 156 39 176 -- "#9C27B0"
            , Color.rgb 103 58 183 -- "#673AB7"
            , Color.rgb 63 81 181 -- "#3F51B5"
            , Color.rgb 33 150 243 -- "#2196F3"
            , Color.rgb 3 169 244 -- "#03A9F4"
            , Color.rgb 0 188 212 -- "#00BCD4"
            , Color.rgb 0 150 136 -- "#009688"
            , Color.rgb 76 175 80 -- "#4CAF50"
            , Color.rgb 139 195 74 -- "#8BC34A"
            , Color.rgb 205 220 57 -- "#CDDC39"
            , Color.rgb 255 235 59 -- "#FFEB3B"
            , Color.rgb 255 193 7 -- "#FFC107"
            , Color.rgb 255 152 0 -- "#FF9800"
            , Color.rgb 255 87 34 -- "#FF5722"
            , Color.rgb 121 85 72 -- "#795548"
            , Color.rgb 158 158 158 -- "#9E9E9E"
            , Color.rgb 96 125 139 -- "#607D8B"
            ]
    in
    case List.head <| List.drop index colors of
        Just a ->
            a

        Nothing ->
            Color.rgb 0 0 0


model : Model
model =
    { entities = Entities.empty
    , size = { width = 0, height = 0 }
    , playerColor = Dict.empty
    }


removeInTime : Entities.Id -> Cmd MainMessage.Message
removeInTime id =
    Process.sleep (1.5 * Time.second)
        |> Task.perform (\_ -> MainMessage.Game (Protocol.Entity (Protocol.Remove id)))


update : Message -> Model -> ( Model, Cmd MainMessage.Message )
update msg model =
    case msg of
        Protocol.Entity (Protocol.Add e) ->
            let
                ( newModel, cmd ) =
                    case e of
                        Entities.Explosion id _ ->
                            ( model, removeInTime id )

                        Entities.Player id _ ->
                            let
                                _ =
                                    Debug.log "Assign color to player here" <| Dict.insert id (Dict.size model.playerColor |> colorPalette) model.playerColor
                            in
                            ( { model
                                | playerColor =
                                    if Dict.member id model.playerColor |> not then
                                        Dict.insert id (Dict.size model.playerColor |> colorPalette) model.playerColor
                                    else
                                        model.playerColor
                              }
                            , Cmd.none
                            )

                        _ ->
                            ( model, Cmd.none )
            in
            ( { newModel
                | size = updateSize model.size (Entities.position e)
                , entities = Entities.add [ e ] model.entities
              }
            , cmd
            )

        Protocol.Entity (Protocol.Remove id) ->
            ( { model
                | entities = Entities.remove [ id ] model.entities
              }
            , Cmd.none
            )

        _ ->
            ( model, Cmd.none )


updateSize : FloorSize -> Point -> FloorSize
updateSize size (Point x y) =
    { width = max size.width (x + 1), height = max size.height (y + 1) }
