module Util.Auth exposing (..)

import Api.User exposing (AccessToken)
import Spa.Document exposing (Document)

import Element exposing (text)

protected : 
    (AccessToken -> { model | token : Maybe AccessToken } -> Document msg)
    -> { model | token : Maybe AccessToken }
    -> Document msg
protected view model =
    case model.token of
        Just token ->
            view token model

        Nothing -> 
            { title = "401"
            , body = [ text "You are not authorized to view this page" ]
            }