module Client.GUI.Main exposing (..)

-- import Dict

import Client.GUI.View.Create as Create
import Client.GUI.View.GameList as GameList
import Client.GUI.View.WaitForPlayers as WaitForPlayers
import Client.Port as Port


type Model
    = Lobby GameList.Data
    | WaitForPlayers WaitForPlayers.Data
    | BuildingRoom Create.Data
    | Settings
    | Dead
    | Win
    | Tutorial
    | Loading
    | None


type Events
    = OnNameChange String
    | Start
    | End Create.Data


type Msg
    = RequestServerList
    | ServerList GameList.Data
    | Join String
    | Creating Events
    | ShowTutorial
    | ShowSettings
    | ShowDead
    | ShowWin


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Join room ->
            ( model, Port.join room )

        Creating Start ->
            ( BuildingRoom Create.default, Cmd.none )

        Creating (OnNameChange name) ->
            ( BuildingRoom { name = name }, Cmd.none )

        Creating (End a) ->
            ( Loading, Port.create a.name )

        ServerList data ->
            ( Lobby data, Cmd.none )

        RequestServerList ->
            ( Loading, Port.serverListRequest () )

        ShowTutorial ->
            ( Tutorial, Cmd.none )

        ShowSettings ->
            ( Settings, Cmd.none )

        ShowDead ->
            ( Dead, Cmd.none )

        ShowWin ->
            ( Win, Cmd.none )
