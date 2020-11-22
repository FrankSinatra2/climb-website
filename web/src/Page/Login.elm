module Page.Login exposing (Model, Msg, view, init, update, toSession)

import Json.Encode as Encode
import Session exposing (Session)
import Html exposing (Html, form)
import Http
import Element.Input as Input
import Element as E
import Element.Background as Background
import Element.Border as Border

import Api exposing (Auth)
import Route exposing (Route)

type alias Model =
    { session : Session
    , form : Form
    }

type alias Form =
    { username : String
    , password : String
    }

type Msg
    = SubmittedForm
    | EnteredUsername String
    | EnteredPassword String
    | CompletedLogin (Result Http.Error Auth)
    | GotSession Session

init : Session -> (Model, Cmd msg)
init session = 
    ( { session = session
      , form = 
            { username = ""
            , password = ""
            }
      }
    , Cmd.none   
    )


view : Model -> Html Msg
view model =
    let
        usernameInput 
            = E.el
                [E.paddingXY 3 15] 
                (Input.username 
                    []
                    { onChange = EnteredUsername
                    , text = model.form.username
                    , placeholder = Nothing
                    , label = Input.labelAbove [] <| E.text "Username"
                    }
                )

        passwordInput
            = E.el
                [E.paddingXY 3 15] 
                (Input.currentPassword
                    []
                    { onChange = EnteredPassword
                    , text = model.form.password
                    , placeholder = Nothing
                    , label = Input.labelAbove [] <| E.text "Password"
                    , show = False
                    }
                )
            
        submitButton
            = E.el
                [ E.paddingXY 3 15
                , E.width E.fill
                , Background.color <| E.rgb 0.72 0.14 0.14
                ]
                (Input.button
                    [E.centerX]
                    { onPress = Just SubmittedForm
                    , label = E.text "Login"
                    }
                )

        card =
            E.column
                [ Border.shadow { offset = (3.0, 3.0), size = 1.0, blur = 5.0, color = E.rgba 0.0 0.0 0.0 0.23 }
                , E.paddingXY 10 10
                -- , E.height <| E.px 175
                , E.centerX
                , E.centerY
                , Background.color <| E.rgb 1.0 1.0 1.0
                -- , E.width <| E.px 250
                ]
                [ usernameInput
                , passwordInput
                , submitButton
                ]

    in
        E.layout [ Background.color <| E.rgb 0.95 0.95 0.95 ] card

    
update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of
        SubmittedForm ->
            (model, Http.send CompletedLogin (login model.form))

        EnteredUsername username ->
            updateForm (\f -> {f | username = username}) model

        EnteredPassword password ->
            updateForm (\f -> {f | password = password}) model

        CompletedLogin (Err error) ->
            (model, Cmd.none)

        CompletedLogin (Ok auth) ->
            (model, Api.storeAuthToken auth)

        GotSession session ->
            ({model | session = session}, Route.replaceUrl (Session.navKey session) Route.Home)


updateForm : (Form -> Form) -> Model -> (Model, Cmd Msg)
updateForm tx model =
    ({ model | form = tx model.form}, Cmd.none)


subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)

toSession : Model -> Session
toSession model = model.session

login : Form -> Http.Request Auth
login form =
    let
        body =
            Encode.object
                [ ("username", Encode.string form.username)
                , ("password", Encode.string form.password)
                ]
            |> Http.jsonBody
    in
        Api.authenticate body Api.authDecoder