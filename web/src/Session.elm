module Session exposing (..)

import Api exposing (Auth)
import Browser.Navigation as Nav

type Session
    = LoggedIn Nav.Key Auth
    | Guest Nav.Key


auth : Session -> Maybe Auth
auth session =
    case session of
        LoggedIn _ val ->
            Just val

        Guest _ ->
            Nothing

navKey : Session -> Nav.Key
navKey session =
    case session of
        LoggedIn val _ ->
            val
        
        Guest val ->
            val

fromAuth : Nav.Key -> Maybe Auth -> Session
fromAuth key maybeAuth =
    case maybeAuth of
        Just authVal ->
            LoggedIn key authVal

        Nothing ->
            Guest key

changes : (Session -> msg) -> Nav.Key -> Sub msg
changes toMsg key =
    Api.tokenChanges (\maybeAuth -> toMsg (fromToken key maybeAuth)) Api.authDecoder

fromToken : Nav.Key -> Maybe Auth -> Session
fromToken key maybeAuth =
    case maybeAuth of
        Just val ->
            LoggedIn key val

        Nothing ->
            Guest key
