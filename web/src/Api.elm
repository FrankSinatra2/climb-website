port module Api exposing (..)

import Http exposing (Body, Expect)
import Json.Decode as Decode exposing (Decoder, Value, decodeString, field, string, map)
import Json.Encode as Encode
import Api.Endpoint as Endpoint exposing (Endpoint)

type Auth =
    Auth String

authHeader : Auth -> Http.Header
authHeader (Auth token) =
    Http.header "Authorization" ("Bearer " ++ token)


authDecoder : Decoder Auth
authDecoder =
    field "access_token" string |> map Auth

-- Hit API Endpoints

authenticate : Http.Body -> Decoder Auth -> Http.Request Auth
authenticate body decoder =
    post Endpoint.authenticate Nothing body authDecoder

signup : Http.Body -> Decoder Auth -> Http.Request Auth
signup body decoder =
    post Endpoint.signup Nothing body authDecoder

logout : Cmd msg
logout =
    storeCache Nothing

-- Speak With The API
get : Endpoint -> Maybe Auth -> Decoder a -> Http.Request a
get url maybeAuth decoder =
    Endpoint.request
        { method = "GET"
        , url = url
        , expect = Http.expectJson decoder
        , headers = 
            case maybeAuth of
                Just auth ->
                    [ authHeader auth]
                Nothing ->
                    []
        , body = Http.emptyBody
        , timeout = Nothing
        , withAuthentication = False
        }

post : Endpoint -> Maybe Auth -> Body -> Decoder a -> Http.Request a
post url maybeAuth body decoder =
    Endpoint.request
        { method = "POST"
        , url = url
        , expect = Http.expectJson decoder
        , headers = 
            case maybeAuth of
                Just auth -> 
                    [ authHeader auth ]
                Nothing ->
                    []
        , body = body
        , timeout = Nothing
        , withAuthentication = False
        }


-- Storing Auth Token


port storeCache : Maybe Value -> Cmd msg
port onStoreChange : (Value -> msg) -> Sub msg


storeAuthToken : Auth -> Cmd msg
storeAuthToken (Auth token) =
    let
        json =
            Encode.object
                [("token", Encode.string token)]    
    in
        storeCache (Just json)

tokenChanges : (Maybe token -> msg) -> Decoder (String -> token) -> Sub msg
tokenChanges toMsg decoder =
    onStoreChange (\value -> toMsg (decodeFromChange decoder value))

decodeFromChange : Decoder (String -> token) -> Value -> Maybe token
decodeFromChange tokenDecoder val = 
    Decode.decodeValue (storageDecoder tokenDecoder) val
        |> Result.toMaybe

storageDecoder : Decoder (String -> token) -> Decoder token
storageDecoder tokenDecoder =
    Decode.field "token" (decoderFromAuth tokenDecoder)

decoderFromAuth : Decoder (String -> a) -> Decoder a
decoderFromAuth decoder =
    Decode.map2 (\fromAuth auth -> fromAuth auth)
        decoder
        authDecoder