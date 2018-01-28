--TODO update to Client.Game


module Client.Game.Main exposing (Message, Model, model, update)

import Common.Point exposing (Point(Point))
import Game.Entities as Entities exposing (Entities)
import Shared.Protocol as Protocol


type alias FloorSize =
    { width : Int, height : Int }


type alias Model =
    { entities : Entities
    , size : FloorSize
    }


type alias Message =
    Protocol.Message


model : Model
model =
    { entities = Entities.empty
    , size = { width = 0, height = 0 }
    }


update : Message -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Protocol.Entity (Protocol.Add e) ->
            ( { model
                | size = updateSize model.size (Entities.position e)
                , entities = Entities.add [ e ] model.entities
              }
            , Cmd.none
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
