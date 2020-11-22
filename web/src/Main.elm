module Main exposing (..)

import Browser exposing (Document)
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url

import Page.Login as Login
import Page.Blank as Blank
import Session exposing (fromAuth)
import Session exposing (Session)
import Route exposing (Route)
import Browser exposing (UrlRequest)


type Model
    = Redirect Session
    | NotFound Session
    | Login Login.Model

type Msg
    = ClickedLink Browser.UrlRequest
    | ChangedUrl Url.Url
    | GotLoginMsg Login.Msg

main : Program () Model Msg
main = 
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = ChangedUrl
        , onUrlRequest = ClickedLink
        }

init : () -> Url.Url -> Nav.Key -> (Model, Cmd Msg)
init flags url key =
    changeRouteTo (Route.fromUrl url)
        (Redirect (Session.fromAuth key Nothing))


view : Model -> Document Msg
view model =
    let
        body = case model of
            Redirect _ ->
                Blank.view
            Login m ->
                Html.map GotLoginMsg <| Login.view m
            NotFound _ ->
                Blank.view
    in
    { title = "Climbing Exploration"
    , body = [ body ]
    }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case (msg, model) of
        (ClickedLink urlRequest, _) ->
            case urlRequest of
                Browser.Internal url ->
                    case url.fragment of
                        Nothing ->
                            (model, Cmd.none)

                        Just _ ->
                            (model, Nav.pushUrl (Session.navKey (toSession model)) (Url.toString url))

                Browser.External href ->
                    (model, Nav.load href)
        
        (ChangedUrl url, _) ->
            changeRouteTo (Route.fromUrl url) model

        (GotLoginMsg subMsg, Login login) ->
            Login.update subMsg login
                |> updateWith Login GotLoginMsg model

        (_,_) ->
            (model, Cmd.none)
        


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> Model -> (subModel, Cmd subMsg) -> (Model, Cmd Msg)
updateWith toModel toMsg model (subModel, subCmd) =
    (toModel subModel, Cmd.map toMsg subCmd)

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


toSession : Model -> Session
toSession model =
    case model of
        NotFound s ->
            s

        Redirect s ->
            s

        Login m ->
            Login.toSession m
        

changeRouteTo : Maybe Route -> Model -> (Model, Cmd Msg)
changeRouteTo maybeRoute model =
    let
        session = toSession model
    in
    case maybeRoute of
        Nothing ->
            (NotFound session, Cmd.none)
        
        Just Route.Home ->
            (NotFound session, Cmd.none)

        Just Route.Login ->
            Login.init session
                |> updateWith Login GotLoginMsg model