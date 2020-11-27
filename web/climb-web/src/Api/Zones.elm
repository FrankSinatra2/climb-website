module Api.Zones exposing (Zone, decodeZone, fetchZones)

import Json.Decode as Json
import Api
import Http
import String exposing(fromInt)
import Api.PaginatedList exposing (PaginatedList)
import Api.PaginatedList exposing (decodePageLinks)
import Api.PaginatedList exposing (decodePaginatedList)

type alias Zone = 
    { id : String
    , latitude : Float
    , longitude : Float
    , title : String
    }


decodeZone : Json.Decoder Zone
decodeZone =
    Json.map4 Zone
        (Json.field "id" Json.string)
        (Json.field "latitude" Json.float)
        (Json.field "longitude" Json.float)
        (Json.field "title" Json.string)


paramsToUrl : { page : Int, limit : Int} -> String
paramsToUrl config = Api.climbApi ++ "/zones?page=" ++ (fromInt config.page) ++ "&limit=" ++ (fromInt config.limit)


fetchZones : 
    { page : Int, limit : Int}
    -> { onResponse : Api.Data (PaginatedList Zone) -> msg}
    -> Cmd msg
fetchZones params options =
    Http.get
        { url = paramsToUrl params
        , expect = Api.expectJson options.onResponse (decodePaginatedList (Json.list decodeZone))
        }