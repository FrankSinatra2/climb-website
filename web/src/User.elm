module User exposing (..)

import Json.Decode as Decode exposing (Decoder, map, map2, field, string)

type User = User Internals

type alias Internals =
    { id : String
    , username : String
    }


id : User -> String
id (User info) = info.id

userName : User -> String
userName (User info) = info.username


decoder : Decoder User
decoder =
    map2 Internals
        (field "id" string)
        (field "username" string)
    |> map User