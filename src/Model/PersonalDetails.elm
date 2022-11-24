module Model.PersonalDetails exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, classList, id, href)


type alias DetailWithName =
    { name : String
    , detail : String
    }


type alias PersonalDetails =
    { name : String
    , contacts : List DetailWithName
    , intro : String
    , socials : List DetailWithName
    , repo_addr : String
    }


view : PersonalDetails -> Html msg
view details =
    div [] 
    ([ h1 [id "name"] [text details.name]
    ,  em [id "intro"] [text details.intro]]
    ++ (details.contacts |> List.map (\contact -> p [class "contact-detail"][text contact.detail]))
    ++ (details.socials |> List.map (\socials -> a [href socials.detail, class "social-link"][text socials.name]))
    )
    -- Debug.todo "Implement the Model.PersonalDetails.view function"
