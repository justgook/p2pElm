module Client.Update exposing (..)

import Client.GUI.Main as ClientGUI
import Client.Game.Main as Game
import Client.Message as Message exposing (Message)
import Client.Model as Model exposing (Model)
import Client.Port as Port
import Dict
import Keyboard exposing (KeyCode)
import Task


update : Message -> Model -> ( Model, Cmd Message )
update msg model =
    case msg of
        Message.Location loc ->
            let
                _ =
                    Debug.log "Message.Location" loc
            in
            ( model, Cmd.none )

        Message.NewConnection i ->
            let
                _ =
                    Debug.log "Message.NewConnection IN MAIN LOOP WORKS!!" i
            in
            update (Message.GUI ClientGUI.Hide) model

        Message.Game msg ->
            Game.update msg model.game
                |> Tuple.mapFirst (\m -> { model | game = m })

        Message.GUI guiMsg ->
            ClientGUI.update guiMsg model.gui
                |> Tuple.mapFirst (\m -> { model | gui = m })

        Message.KeyDown key ->
            ( model, keyToOut key )

        Message.Resize device ->
            ( { model | device = device }, Cmd.none )


send : msg -> Cmd msg
send msg =
    Task.succeed msg
        |> Task.perform identity


keyToOut : KeyCode -> Cmd msg
keyToOut =
    flip Dict.get
        (Dict.fromList
            [ ( 38, 2 ) -- Up: 2,
            , ( 39, 3 ) -- Right: 3,
            , ( 40, 4 ) -- Down: 4,
            , ( 37, 5 ) -- Left: 5,
            , ( 32, 6 ) -- Bomb: 6,
            ]
        )
        >> Maybe.map Port.client_outcome
        >> Maybe.withDefault Cmd.none



-- update : Msg -> Model -> ( Model, Cmd Msg )
-- update msg model =
--     case msg of
--         KeyPressed ( key, time ) ->
--             ( model, time |> Task.map (\x -> ( key, x )) |> Task.perform TimeUpdated )
--         TimeUpdated ( key, time ) ->
--             if (Time.inSeconds time - Time.inSeconds model.time) < 2 then
--                 model ! []
--             else
--                 ( { model | time = time, message = key |> toString }, Cmd.none )
