module Client.Update exposing (..)

import Client.GUI.Main as ClientGUI
import Client.Message as Message exposing (Message)
import Client.Model as Model exposing (Model)
import Client.Port as Port
import Dict
import Keyboard exposing (KeyCode)


update : Message -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Message.Income incomeMsg ->
            let
                _ =
                    Debug.log "Implement Me Client::Update::update Message.Income" ""
            in
            ( model, Cmd.none )

        Message.GUI guiMsg ->
            ClientGUI.update guiMsg model.page
                |> Tuple.mapFirst (\m -> { model | page = m })

        Message.KeyDown key ->
            ( model, keyToOut key )

        Message.Resize device ->
            ( { model | device = device }, Cmd.none )


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
        >> Maybe.map Port.clientAction
        >> Maybe.withDefault Cmd.none
