--TODO update to Client.GUI


module Client.GUI.Main exposing (..)

-- import Dict

import Client.GUI.View.Create as Create
import Client.GUI.View.GameList as GameList
import Client.GUI.View.WaitForPlayers as WaitForPlayers
import Client.Port as Port
import Navigation exposing (Location)


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
    = Init Location
    | RequestServerList
    | ServerList GameList.Data
    | Join String
    | Creating Events
    | ShowTutorial
    | ShowSettings
    | ShowDead
    | ShowWin
    | Hide


model : Model
model =
    Loading


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Join room ->
            ( model, Port.client_join room )

        Creating Start ->
            ( BuildingRoom { name = "" }, Navigation.newUrl "/#/create" )

        Creating (OnNameChange name) ->
            ( BuildingRoom { name = name }, "/#/create/" ++ name |> Navigation.modifyUrl )

        Creating (End a) ->
            ( Loading, Port.client_create a.name )

        ServerList data ->
            ( Lobby data, Cmd.none )

        RequestServerList ->
            Loading ! [ Navigation.newUrl "/#/", Port.client_serverListRequest () ]

        ShowTutorial ->
            ( Tutorial, Navigation.newUrl "/#/tutorial" )

        ShowSettings ->
            ( Settings, Navigation.newUrl "/#/settings" )

        ShowDead ->
            ( Dead, Cmd.none )

        ShowWin ->
            ( Win, Cmd.none )

        Hide ->
            ( None, Cmd.none )

        Init loc ->
            case String.split "/" loc.hash of
                "#" :: "create" :: name :: rest ->
                    ( BuildingRoom { name = name }, Cmd.none )

                "#" :: "tutorial" :: _ ->
                    ( Tutorial, Cmd.none )

                "#" :: "settings" :: _ ->
                    ( Settings, Cmd.none )

                _ ->
                    Loading ! [ Navigation.newUrl "/#/", Port.client_serverListRequest () ]
