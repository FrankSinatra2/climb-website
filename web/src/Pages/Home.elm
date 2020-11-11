module Pages.Home exposing (..)
import Element.Region exposing (description)


-- MODEL

type alias Zone =
    { name : String
    , id : String
    }

type alias LatLong =
    { lat : Float
    , long : Float 
    }

type alias Description = 
    { location : LatLong
    , review : String
    }

type SlideShow = SlideShow String SlideShow SlideShow | Empty

type alias Model =
    { activeZone : Zone
    , zones : List Zone
    , activeSubZone : Zone
    , subZones : List Zone
    , slideShow : SlideShow
    , description : Description
    }

-- MESSAGE

type Msg = Noop 
         | ClickSubZone Zone 
         | ClickZone Zone 
         | ClickNext SlideShow
         | ClickPrev SlideShow



-- INIT

init : Model
init =
    { 

    }