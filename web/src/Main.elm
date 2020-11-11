module Main exposing (..)

import Browser
import Html exposing (Html)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Input as Input
import Element.Region exposing (description)
import Html.Attributes exposing (hidden)
import Element.Font as Font


main =
    Browser.element 
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view 
        }

type alias ZoneModel =
    { name : String
    }

type SlideShow = SlideShow String SlideShow SlideShow | Empty

type alias Description =
    { location : String
    , review : String
    }

type alias Model =
    { zones : { elements : List ZoneModel, active : ZoneModel }
    , slideShow : SlideShow
    , description : Description
    , subZones : { elements : List ZoneModel, active : ZoneModel }
    }

type Msg = Noop

edges = 
    { right = 0
    , left = 0
    , top = 0
    , bottom = 0
    }

tempZones = 
    [ { name = "zone 1" }
    , { name = "zone 2" }
    , { name = "zone 3" }
    , { name = "zone 4" }
    , { name = "zone 5" }
    ]

tempSubZones =
    [ { name = "subzone a" }
    , { name = "subzone b" }
    , { name = "subzone c" }
    ]

init : () -> (Model, Cmd Msg)
init _ =
    (
        { zones = { elements = tempZones, active = { name = "zone 1" }}
        , slideShow = Empty
        , description = { location = "sunriver", review = "pretty good" }
        , subZones = { elements = tempSubZones, active = { name = "subzone b" }}
        }
        , Cmd.none
    )

subscriptions : Model -> Sub Msg 
subscriptions model =
    Sub.none

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = ( model, Cmd.none )

view : Model -> Html Msg
view model =
    let
        mainZones = mainZonesView model.zones.elements model.zones.active
        content = 
            column 
                [ width <| fillPortion 3
                , height fill
                , paddingEach { edges | left = 32, right = 32 }
                , spacingXY 0 32
                ] 
                [ slideShowView model.slideShow
                , descriptionView model.description
                ]
        subZones = subZonesView model.subZones.elements model.subZones.active
    in
        layout
            [ paddingXY 32 32
            , width fill
            , height <| px 800
            , Background.color <| Element.rgb 0.95 0.95 0.95 
            ]
            ( row 
                [ width fill
                , height fill 
                ] 
                [ mainZones
                , content
                , subZones 
                ] 
            )

zoneRow : ZoneModel -> ZoneModel -> Element msg
zoneRow zone activeZone = 
    let
        color = 
            if zone.name == activeZone.name then
                Element.rgb 0.0 0.3 0.7
            else
                Element.rgb 1.0 1.0 1.0
    in
        el
            [ paddingXY 0 8
            , width fill
            , Background.color color
            ]
            ( text zone.name )
mainZonesView : List ZoneModel -> ZoneModel -> Element msg
mainZonesView zones active =
    let
        zoneRows = 
            List.map
                (\x -> zoneRow x active )
                zones
    in
        column
            [ width <| fillPortion 1
            , Border.shadow { offset = (3.0, 3.0), size = 1.0, blur = 5.0, color = Element.rgba 0.0 0.0 0.0 0.23 }
            , height fill
            , Background.color <| Element.rgb 1.0 1.0 1.0
            , paddingXY 16 16 
            ]
            zoneRows

slideShowView : SlideShow -> Element msg
slideShowView model = 
    let
        content = 
            case model of
                SlideShow url prev next ->
                    el [] ( text url )
                Empty ->
                    el [] ( text "This zone has no images" )
    in
        el 
            [ Border.shadow { offset = (3.0, 3.0), size = 1.0, blur = 5.0, color = Element.rgba 0.0 0.0 0.0 0.23 }
            , height <| fillPortion 2
            , width fill
            , Background.color <| Element.rgb 1.0 1.0 1.0
            , paddingXY 16 16
            ] 
            content

descriptionView : Description -> Element msg
descriptionView model =
    let
        header = el [ Font.alignLeft, Font.size 18, Font.heavy ] ( text model.location )

        body = el [ alignLeft ] ( text model.review )

    in
        column
            [ height <| fillPortion 1
            , width fill
            , Border.shadow { offset = (3.0, 3.0), size = 1.0, blur = 5.0, color = Element.rgba 0.0 0.0 0.0 0.23 }
            , Background.color <| Element.rgb 1.0 1.0 1.0
            , paddingXY 16 16
            ]
            [ header
            , body
            ]

subZonesView : List ZoneModel -> ZoneModel -> Element msg
subZonesView zones active =
    let
        zoneRows = 
            List.map
                (\x -> zoneRow x active )
                zones
    in
        column
            [ width <| fillPortion 1
            , height fill
            , Border.shadow { offset = (3.0, 3.0), size = 1.0, blur = 5.0, color = Element.rgba 0.0 0.0 0.0 0.23 }
            , Background.color <| Element.rgb 1.0 1.0 1.0
            , paddingXY 16 16
            ]
            zoneRows