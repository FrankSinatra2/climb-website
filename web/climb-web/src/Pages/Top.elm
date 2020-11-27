module Pages.Top exposing (Params, Model, Msg, page)

import Shared
import Spa.Document exposing (Document)
import Spa.Page as Page exposing (Page)
import Util.Auth
import Api exposing (Data(..))
import Api.Zones as Zone exposing (Zone)
import Api.SubZones as SubZone exposing (SubZone)
import Api.PaginatedList as PaginatedList exposing (PaginatedList)
import Api
import Api.User exposing (AccessToken)
import Spa.Url as Url exposing (Url)
import Browser.Navigation as Nav
import String exposing (fromInt)
import List exposing (length)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Material
import Html exposing (select)
import String exposing (fromFloat)
import Element.Region exposing (description)
import Api.Image as Image exposing (Image)
import List exposing (maximum)
import Set exposing (empty)

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
    , selectedZone : Maybe Zone
    , subZones : Api.Data (PaginatedList SubZone)
    , selectedSubZone : Maybe SubZone
    , slideshow : Api.Data (PaginatedList Image)
    , selectedImage : Maybe Image
    }


firstPageParams : { page : Int, limit : Int }
firstPageParams = { page = 1, limit = 10 }


init : Shared.Model -> Url Params -> ( Model, Cmd Msg )
init shared { params } =
    ( { key = shared.key
      , token = shared.token
      , zones = Loading
      , selectedZone = Nothing
      , subZones = NotAsked
      , selectedSubZone = Nothing
      , slideshow = NotAsked
      , selectedImage = Nothing
      }
    , Zone.fetchZones firstPageParams { onResponse = GotPaginatedZones }
    )



-- UPDATE


type Msg
    = ReplaceMe
    | SelectedZone Zone
    | SelectedSubZone SubZone
    | GotPaginatedZones (Api.Data (PaginatedList Zone))
    | GotPaginatedSubZones (Api.Data (PaginatedList SubZone))
    | GotPaginatedImages (Api.Data (PaginatedList Image))
    | SlideshowNext (PaginatedList Image)
    | SlideshowPrev (PaginatedList Image)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReplaceMe ->
            ( model, Cmd.none )

        GotPaginatedZones list ->
            ({ model | zones = list}, Cmd.none)

        SelectedZone zone ->
            ( { model | selectedZone = Just zone, selectedSubZone = Nothing, selectedImage = Nothing }
            , SubZone.fetchSubZones zone firstPageParams { onResponse = GotPaginatedSubZones })

        GotPaginatedSubZones list ->
            ({ model | subZones = list}, Cmd.none)

        SelectedSubZone subZone ->
            ( { model | selectedSubZone = Just subZone}
            , Image.fetchSlideshow subZone {page = 1, limit = 1} { onResponse = GotPaginatedImages })

        GotPaginatedImages slideshow ->
            ( { model | slideshow = slideshow
              , selectedImage = 
                    case slideshow of
                        Success images ->
                            List.head (PaginatedList.records images)
                        
                        _ ->
                            Nothing
              }
            , Cmd.none)

        SlideshowNext show ->
            ( model, Image.nextImage show { onResponse = GotPaginatedImages })

        SlideshowPrev show ->
            (model, Image.prevImage show { onResponse = GotPaginatedImages })

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

edges = 
    { right = 0
    , left = 0
    , top = 0
    , bottom = 0
    }

view : AccessToken -> Model -> Document Msg
view token model =
    let
        zones = viewZones model
        subZones = viewSubZones model

        content = 
            column
                [ width <| fillPortion 3
                , height fill
                , paddingEach { edges | left = 32, right = 32 }
                , spacingXY 0 32
                ]
                [ viewSlideShow model
                , viewDescription model
                ]

        mainView =
            row
                [ paddingXY 16 16 
                , width fill 
                , height fill
                ]
                [ zones, content, subZones]
    in
        { title = "Top"
        , body = [ mainView ]
        }

viewZones : Model -> Element Msg
viewZones model =
    case model.zones of
        Loading ->
            el [] (text "Loading...")

        Success list ->
            zoneCard SelectedZone model.selectedZone (PaginatedList.records list)
            
        Failure err ->
            el [] (text "Error...")

        NotAsked ->
            zoneCard SelectedZone Nothing []


viewSubZones : Model -> Element Msg
viewSubZones model =
    case model.subZones of
        Loading -> 
            el [] (text "Loading")

        Success list ->
            zoneCard SelectedSubZone model.selectedSubZone (PaginatedList.records list)

        NotAsked ->
            zoneCard SelectedSubZone Nothing []

        Failure err ->
            el [] (text "Error...")

viewSlideShow : Model -> Element Msg
viewSlideShow model =
    let
        toShow =
            case model.slideshow of
                NotAsked ->
                    ( text "You Haven't Selected A SubZone Yet")

                Failure _ ->
                    ( text "An Error Occurred..." )

                Loading ->
                    ( text "Loading..." )

                Success show ->
                    case model.selectedImage of
                        Nothing ->
                            (text "No Images")

                        Just i ->
                            let 
                                pic = 
                                    image
                                        [ width fill
                                        , height fill
                                        , paddingEach {edges | bottom = 16}
                                        , clipY
                                        ]
                                        { src = Image.imageUrl i
                                        , description = "Image of a climbing location"
                                        }

                                leftControl =
                                    el
                                        [ height fill
                                        , width fill
                                        , Events.onClick (SlideshowPrev show)
                                        ]
                                        (none)

                                rightControl =
                                    el
                                        [ height fill
                                        , width fill
                                        , Events.onClick (SlideshowNext show)
                                        ]
                                        (none)
                            in
                                row
                                    [ width fill
                                    , height fill
                                    , behindContent pic
                                    , paddingXY 0 10
                                    ]
                                    [ leftControl
                                    , rightControl
                                    ]

    in
        el 
            [ Border.shadow { offset = (3.0, 3.0), size = 1.0, blur = 5.0, color = Element.rgba 0.0 0.0 0.0 0.23 }
            , height (fillPortion 3)
            , width fill
            , Background.color <| Element.rgb 1.0 1.0 1.0
            , paddingXY 16 16
            , scrollbarY
            ] 
            toShow


viewDescription : Model -> Element Msg
viewDescription model =
    let
        locationText =
            case model.selectedZone of
                Nothing ->
                    (text "No Zone Selected")

                Just zone ->
                    (text <| (fromFloat zone.latitude) ++ ", " ++ (fromFloat zone.longitude))
    


        descriptionText =
            case model.selectedSubZone of
                Nothing ->
                    (text "No Sub Zone Selected")

                Just zone ->
                    (text zone.description)

        location =
            column
                [ width fill ]
                [ el [] (text "Location")
                , el [] locationText
                ]

        description =
            column
                [ width fill ]
                [ el [] (text "Description")
                , el [] descriptionText
                ]
    in
        column
            [ height <| minimum 200 <| fillPortion 1
            , width fill
            , Border.shadow { offset = (3.0, 3.0), size = 1.0, blur = 5.0, color = Element.rgba 0.0 0.0 0.0 0.23 }
            , Background.color <| Element.rgb 1.0 1.0 1.0
            , paddingXY 16 16
            ]
            [ location
            , description
            ]

zoneCard : 
    ({ a | id : String, title : String } -> Msg)
    -> Maybe { a | id : String, title : String }
    -> List { a | id : String, title : String }
    -> Element Msg
zoneCard toMsg selectedZone zones =
    let
        
        highlight zone = 
            case selectedZone of
                Nothing ->
                    Background.color Material.white

                Just z ->
                    if z.id == zone.id then
                        Background.color Material.primary
                    else
                        Background.color Material.white
        links zone =
            el
                [ highlight zone
                , width fill
                , paddingXY 0 10
                , Events.onClick (toMsg zone)
                , Font.center
                ]
                ( text zone.title )


        titles = List.map links zones
    in
        column
            [ width <| fillPortion 1
            , Border.shadow { offset = (3.0, 3.0), size = 1.0, blur = 5.0, color = Element.rgba 0.0 0.0 0.0 0.23 }
            , height fill
            , Background.color Material.white
            , paddingXY 0 16 
            ]   
            titles



