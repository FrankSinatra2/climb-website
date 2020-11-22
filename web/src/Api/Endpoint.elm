module Api.Endpoint exposing (..)

import Http
import Url.Builder exposing (QueryParameter)



type Endpoint = Endpoint String

type alias ApiRequest a =
    { body : Http.Body
    , expect : Http.Expect a
    , headers : List Http.Header
    , method : String
    , timeout : Maybe Float
    , url : Endpoint
    , withAuthentication : Bool
    }

request : ApiRequest a -> Http.Request a
request config =
    Http.request 
        { body = config.body
        , expect = config.expect
        , headers = config.headers
        , method = config.method
        , timeout = config.timeout
        , url = unwrap config.url
        , withCredentials = config.withAuthentication
        }

unwrap : Endpoint -> String
unwrap (Endpoint s) = s

url : List String -> List QueryParameter -> Endpoint
url paths queryParams =
    Url.Builder.crossOrigin "http://localhost:8080"
        paths
        queryParams
        |> Endpoint

-- USER ROUTES
authenticate : Endpoint
authenticate = 
    url ["users", "authenticate"] []

signup : Endpoint
signup = 
    url ["users"] []


