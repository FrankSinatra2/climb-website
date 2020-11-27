module Api.Image exposing (Image, decodeImage, fetchSlideshow, imageUrl, nextImage, prevImage)

import Json.Decode as Json
import Api
import Http
import String exposing(fromInt)
import Api.PaginatedList exposing (PaginatedList)
import Api.PaginatedList exposing (decodePageLinks)
import Api.PaginatedList exposing (decodePaginatedList)
import Api.SubZones exposing (SubZone)
import Http
import Api

type alias Image =
    { id : String }

decodeImage : Json.Decoder Image
decodeImage =
    Json.map Image Json.string


paramsToUrl : SubZone -> { page : Int, limit : Int } -> String
paramsToUrl subZone config =
    Api.climbApi ++ "/subzones/" ++ subZone.id ++ "/slideshow?page=" ++ (fromInt config.page) ++ "&limit=" ++ (fromInt config.limit)


imageUrl : Image -> String
imageUrl image = Api.climbApi ++ "/images/" ++ image.id

fetchSlideshow :
    SubZone
    -> { page : Int, limit : Int }
    -> { onResponse : Api.Data (PaginatedList Image) -> msg } 
    -> Cmd msg 
fetchSlideshow zone params options =
    Http.get
        { url = paramsToUrl zone params
        , expect = Api.expectJson options.onResponse (decodePaginatedList (Json.list decodeImage))
        }

nextImage : 
    PaginatedList Image
    -> { onResponse : Api.Data (PaginatedList Image) -> msg } 
    -> Cmd msg
nextImage lst options =
    case lst.pageLinks.next of
        Nothing ->
            Cmd.none

        Just url ->
            Http.get
                { url = url
                , expect = Api.expectJson options.onResponse (decodePaginatedList (Json.list decodeImage))
                }

prevImage : 
    PaginatedList Image
    -> { onResponse : Api.Data (PaginatedList Image) -> msg } 
    -> Cmd msg
prevImage lst options =
    case lst.pageLinks.previous of
        Nothing ->
            Cmd.none

        Just url ->
            Http.get
                { url = url
                , expect = Api.expectJson options.onResponse (decodePaginatedList (Json.list decodeImage))
                }
