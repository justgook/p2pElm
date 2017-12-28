port module Main exposing (main)

import Html exposing (div)
import Html.Attributes exposing (class)
import Keyboard exposing (KeyCode)
import Process


type alias Model =
    {}


type Msg
    = KeyDown KeyCode


port startServert :
    ()
    -> Cmd msg -- https://github.com/evancz/guide.elm-lang.org/issues/34


subscriptions : Model -> Sub Msg
subscriptions model =
    -- if model.mute then Sub.none
    -- else
    Sub.batch [ Keyboard.downs KeyDown ]


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



-- http://package.elm-lang.org/packages/elm-lang/lazy/2.0.0/Lazy


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        KeyDown key ->
            let
                _ =
                    Debug.log "Intro::update" Process.kill
            in
            ( model
            , case key of
                32 ->
                    startServert ()

                _ ->
                    Cmd.none
            )


main : Program Never Model Msg



-- TODO find way how chreate Program Never Never Msg


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


view : Model -> Html.Html Msg
view model =
    div [ class "stage" ]
        [ div [ class "layer" ] []
        , div [ class "layer" ] []
        , div [ class "layer" ] []
        , div [ class "layer" ] []
        , div [ class "layer" ] []
        , div [ class "layer" ] []
        , div [ class "layer" ] []
        , div [ class "layer" ] []
        , div [ class "layer" ] []
        , div [ class "layer" ] []
        , div [ class "layer" ] []
        , div [ class "layer" ] []
        , div [ class "layer" ] []
        , div [ class "layer" ] []
        , div [ class "layer" ] []
        , div [ class "layer" ] []
        , div [ class "layer" ] []
        , div [ class "layer" ] []
        , div [ class "layer" ] []
        , div [ class "layer" ] []
        , div [ class "start" ] []
        ]
