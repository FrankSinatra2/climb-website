module Api.SubZones exposing (SubZone, decodeSubZone, fetchSubZones)

import Json.Decode as Json
import Api
import Http
import String exposing(fromInt)
import Api.PaginatedList exposing (PaginatedList)
import Api.PaginatedList exposing (decodePageLinks)
import Api.PaginatedList exposing (decodePaginatedList)
import Api.Zones exposing (Zone)

type alias SubZone =
    { id : String
    , zoneId : String
    , title : String
    , description : String
    }

decodeSubZone : Json.Decoder SubZone
decodeSubZone =
    Json.map4 SubZone
        (Json.field "id" Json.string)
        (Json.field "zone_id" Json.string)
        (Json.field "title" Json.string)
        (Json.field "description" Json.string)


paramsToUrl : Zone -> { page : Int, limit : Int} -> String
paramsToUrl zone config = Api.climbApi ++ "/zones/" ++ zone.id ++ "/subzones?page=" ++ (fromInt config.page) ++ "&limit=" ++ (fromInt config.limit)

fetchSubZones : 
    Zone
    -> { page : Int, limit : Int}
    -> { onResponse : Api.Data (PaginatedList SubZone) -> msg}
    -> Cmd msg
fetchSubZones zone params options = 
    Http.get
        { url = paramsToUrl zone params
        , expect = Api.expectJson options.onResponse (decodePaginatedList (Json.list decodeSubZone))}



