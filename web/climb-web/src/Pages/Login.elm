module Pages.Login exposing (Params, Model, Msg, page)

import Shared
import Spa.Document exposing (Document)
import Spa.Page as Page exposing (Page)
import Spa.Url as Url exposing (Url)
import Spa.Generated.Route as Route

import Element.Input as Input
import Element.Border as Border
import Element.Background as Background
import Element.Font as Font
import Element exposing(..)

import Html exposing (Html)
import Http
import Browser.Navigation as Nav

import Api
import Material
import Api.User exposing (AccessToken)
import Api exposing (Data(..))
import Api.User exposing (UserData)
import Api.User exposing (fromAccessToken)
import Util.Route
import Ports


page : Page Params Model Msg
page =
    Page.application
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        , save = save
        , load = load
        }



-- INIT


type alias Params =
    ()


type alias Model =
    { userData : Api.User.UserData
    , token : Api.Data AccessToken
    , key : Nav.Key
    }


init : Shared.Model -> Url Params -> ( Model, Cmd Msg )
init shared { params } =
    ( { userData = { username = ""
                   , password = ""
                   }
      , token = Api.NotAsked
      , key = shared.key
      }
      , Cmd.none 
    )



-- UPDATE


type Msg
    = EnteredUsername String
    | EnteredPassword String
    | SubmittedForm
    | GotAccessToken (Api.Data AccessToken)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        EnteredUsername s ->
            updateUserData (\ud -> {ud | username = s}) model

        EnteredPassword s -> 
            updateUserData (\ud -> {ud | password = s}) model

        SubmittedForm ->
            (model, Api.User.authenticate model.userData { onResponse = GotAccessToken })

        GotAccessToken data ->
            case data of
                Success val ->
                    ( {model | token = data}
                    , Cmd.batch 
                        [ Ports.saveAccessToken val
                        , Util.Route.navigate model.key Route.Top
                        ]
                    )

                _ ->
                    (model, Cmd.none)



updateUserData : (UserData -> UserData) -> Model -> (Model, Cmd Msg)
updateUserData tx model =
    ({model | userData = tx model.userData}, Cmd.none)

save : Model -> Shared.Model -> Shared.Model
save model shared =
    let
        newToken = case model.token of
            Success token ->
                Just token

            _ ->
                Nothing
    in
        { shared | token = newToken}


load : Shared.Model -> Model -> ( Model, Cmd Msg )
load shared model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


-- VIEW


view : Model -> Document Msg
view model =
    { title = "Login"
    , body = [ viewLoginCard model ]
    }

viewLoginCard : Model -> Element Msg
viewLoginCard model =
    let
        usernameInput =
            el
                []
                ( Input.username
                    []
                    { onChange = EnteredUsername
                    , text = model.userData.username
                    , placeholder = Nothing
                    , label = Input.labelAbove [] (text "Username")
                    }
                )

        passwordInput =
            el
                [ paddingXY 0 15]
                ( Input.currentPassword
                    []
                    { onChange = EnteredPassword
                    , text = model.userData.password
                    , placeholder = Nothing
                    , label = Input.labelAbove [] (text "Password")
                    , show = False
                    }
                )
 
        submitBttn =
            el
                [ width fill
                , Background.color Material.secondary
                , paddingXY 3 6
                , Border.rounded 2
                ]
                ( Input.button
                    [ Font.color Material.textOnSecondary
                    , centerX ]
                    { onPress = Just SubmittedForm
                    , label = text "Login"
                    }
                )
    in
        column 
            [ centerX
            , centerY
            , Border.shadow { offset = (3.0, 3.0), size = 1.0, blur = 5.0, color = rgba 0.0 0.0 0.0 0.23 }
            , Background.color (rgb 1.0 1.0 1.0)
            , paddingXY 15 10
            ] 
            [ usernameInput, passwordInput, submitBttn ]
    