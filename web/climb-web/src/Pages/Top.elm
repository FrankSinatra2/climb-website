module Pages.Top exposing (Params, Model, Msg, page)

import Shared
import Spa.Document exposing (Document)
import Spa.Page as Page exposing (Page)
import Util.Auth
import Api exposing (Data(..))
import Api.Zones as Zone exposing (Zone)
import Api.PaginatedList as PaginatedList exposing (PaginatedList)
import Api
import Api.User exposing (AccessToken)
import Spa.Url as Url exposing (Url)
import Browser.Navigation as Nav
import String exposing (fromInt)
import List exposing (length)
import Element exposing (..)

page : Page Params Model Msg
page =
    Page.application
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = Util.Auth.protected view
        , save = save
        , load = load
        }



-- INIT


type alias Params =
    ()


type alias Model =
    { key : Nav.Key
    , token : Maybe AccessToken
    , zones : Api.Data (PaginatedList Zone)
    }


firstPageParams = Zone.paramsToUrl { page = 1, limit = 10 }


init : Shared.Model -> Url Params -> ( Model, Cmd Msg )
init shared { params } =
    ( { key = shared.key
      , token = shared.token
      , zones = Loading
      }
    , Zone.fetchZones firstPageParams { onResponse = GotPaginatedZones }
    )



-- UPDATE


type Msg
    = ReplaceMe
    | GotPaginatedZones (Api.Data (PaginatedList Zone))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReplaceMe ->
            ( model, Cmd.none )

        GotPaginatedZones list ->
            ({ model | zones = list}, Cmd.none)


save : Model -> Shared.Model -> Shared.Model
save model shared =
    shared


load : Shared.Model -> Model -> ( Model, Cmd Msg )
load shared model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : AccessToken -> Model -> Document Msg
view token model =
    { title = "Top"
    , body = [ viewZones model.zones ]
    }

viewZones : Api.Data (PaginatedList Zone) -> Element Msg
viewZones data =
    case data of
        Loading ->
            el [] (text "Loading...")

        Success list ->
            el [] (text <| fromInt <| length <| PaginatedList.records list)

        Failure err ->
            el [] (text "Error...")

        _ ->
            el [] (text "Don't Care...")