module Client.GUI.View exposing (..)

-- import Common.View.Tutorial as Tutorial
-- import Client.Port as Port
-- import Client.Update as Update exposing (Events(..), Msg(..))

import Client.GUI.Main as Update exposing (Model(..), Msg(..))
import Client.GUI.View.Create as CreateView
import Client.GUI.View.GameList as GameList
import Client.GUI.View.Settings as Settings
import Client.GUI.View.Tutorial as Tutorial
import Client.GUI.View.WaitForPlayers as WaitForPlayers
import Client.Message as Message exposing (Message)
import Common.View.GUI.Page as Page
import Common.View.GUI.Theme exposing (Theme)
import Element as Element exposing (Device, Element)


-- view : Device -> Model -> Html Msg
-- view : Device -> Model -> Element.Element Theme variation msg


view : Device -> Model -> Element Theme variation Message
view device model =
    case model of
        None ->
            Element.empty

        Lobby data ->
            GameList.view device Message.actions data

        WaitForPlayers data ->
            WaitForPlayers.view device data

        BuildingRoom data ->
            CreateView.view device Message.actions data

        Loading ->
            Page.loading device

        Tutorial ->
            Tutorial.view device Message.actions

        Settings ->
            Settings.view device Message.actions

        Dead ->
            Element.empty

        Win ->
            Element.empty



--
-- _ ->
--     Element.empty
-- Tutorial.view model.device |> Element.viewport stylesheet
