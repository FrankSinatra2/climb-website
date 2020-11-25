module Shared exposing
    ( Flags
    , Model
    , Msg
    , init
    , subscriptions
    , update
    , view
    )

import Browser.Navigation exposing (Key)
import Element exposing (..)
import Element.Font as Font
import Element.Background as Background
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route
import Url exposing (Url)
import Api.User exposing (AccessToken)



-- INIT


type alias Flags =
    ()


type alias Model =
    { url : Url
    , key : Key
    , token : Maybe AccessToken
    }


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model url key Nothing
    , Cmd.none
    )



-- UPDATE


type Msg
    = ReplaceMe


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReplaceMe ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view :
    { page : Document msg, toMsg : Msg -> msg }
    -> Model
    -> Document msg
view { page, toMsg } model =
    { title = page.title
    , body = [ 
        row 
            [ width fill
            , height fill
            , Background.color (rgb 0.95 0.95 0.95)
            ]
            page.body
        ]
    }
