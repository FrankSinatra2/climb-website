module Api.User exposing (..)

import Http
import Json.Decode as Json
import Json.Encode as Encode
import Api

type AccessToken
    = AccessToken String

type alias UserData =
    { username : String
    , password : String 
    }

fromAccessToken : AccessToken -> String
fromAccessToken (AccessToken token) = token

decodeAccessToken : Json.Decoder AccessToken
decodeAccessToken =
    Json.map
        AccessToken
        (Json.field "access_token" Json.string)

-- Endpoints

authenticate : UserData -> { onResponse : Api.Data AccessToken -> msg } -> Cmd msg
authenticate userData options =
    let
        body = Encode.object
            [ ("username", Encode.string userData.username)
            , ("password", Encode.string userData.password)
            ]
            |> Http.jsonBody

    in
    Http.post 
        { url = Api.climbApi ++ "/users/authenticate"
        , expect = Api.expectJson options.onResponse decodeAccessToken
        , body = body
        }
