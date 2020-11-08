module Main exposing (..)

import Browser
import Html exposing (Html)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Input as Input


main =
    Browser.element 
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view 
        }


type alias Model =
    { data: String }

type Msg = Noop

init : () -> (Model, Cmd Msg)
init _ =
    (
        { data = "Hello, World" }
        , Cmd.none
    )

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = ( model, Cmd.none )

view : Model -> Html Msg
view model =
    layout
        [ width fill
        ]
        ( column
            [ Border.shadow { offset = (3.0, 3.0), size = 1.0, blur = 5.0, color = Element.rgba 0.0 0.0 0.0 0.23 } 
            , paddingXY 0 32
            , centerX
            ]
            [ el [ centerX ] (text model.data)
            ]
        )