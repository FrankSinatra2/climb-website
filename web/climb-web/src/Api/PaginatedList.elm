module Api.PaginatedList exposing (..)

import Json.Decode as Json

type alias PageLinks =
    { self : String
    , next : Maybe String
    , previous : Maybe String
    , first : Maybe String
    , last : Maybe String
    }


type alias PaginatedList a =
    { pageLinks : PageLinks
    , total : Int
    , records : List a
    }

records : PaginatedList a -> List a
records list = list.records

links : PaginatedList a -> PageLinks
links list = list.pageLinks


total : PaginatedList a -> Int
total list = list.total

decodePageLinks : Json.Decoder PageLinks
decodePageLinks =
    Json.map5 PageLinks
        (Json.field "self" Json.string)
        (Json.field "next" (Json.nullable Json.string))
        (Json.field "previous" (Json.nullable Json.string))
        (Json.field "first" (Json.nullable Json.string))
        (Json.field "last" (Json.nullable Json.string))
        

decodePaginatedList : Json.Decoder (List a) -> Json.Decoder (PaginatedList a)
decodePaginatedList recordDecoder =
    Json.map3 PaginatedList
        (Json.field "links" decodePageLinks)
        (Json.field "total_count" Json.int)
        (Json.field "records" recordDecoder)

