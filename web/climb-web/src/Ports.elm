port module Ports exposing (saveAccessToken, clearAccessToken)

import Api.User exposing (AccessToken)
import Json.Decode as Json
import Json.Encode as Encode
import Api.User exposing (fromAccessToken)

port outgoing :
    { tag : String
    , data : Json.Value
    }
    -> Cmd msg

saveAccessToken : AccessToken -> Cmd msg
saveAccessToken token =
    outgoing 
        { tag = "saveAccessToken"
        , data = Encode.string (fromAccessToken token) 
        }

clearAccessToken : Cmd msg
clearAccessToken =
    outgoing
        { tag = "clearAccessToken"
        , data = Encode.null
        }
