module Model.Event exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Model.Event.Category exposing (EventCategory(..))
import Model.Interval as Interval exposing (Interval)
import Html.Attributes exposing (href)
import List exposing (sortWith)


type alias Event =
    { title : String
    , interval : Interval
    , description : Html Never
    , category : EventCategory
    , url : Maybe String
    , tags : List String
    , important : Bool
    }


categoryView : EventCategory -> Html Never
categoryView category =
    case category of
        Academic ->
            text "Type of event: Academic"

        Work ->
            text "Type of event: Work"

        Project ->
            text "Type of event: Project"

        Award ->
            text "Type of event: Award"


sortByInterval : List Event -> List Event
sortByInterval events =
    sortWith (\e1 e2 -> Interval.compare e1.interval e2.interval) events
    

view : Event -> Html Never
view event =
    let
        eventAttr = 
            if event.important then [class "event", class "event-important"]
            else [class "event"]
    in
        div eventAttr
        [ h3 [class "event-title"][text event.title]
        , p [class "event-description"][event.description]
        , p [class "event-category"][categoryView event.category]
        , div [class "event-interval"] [Interval.view event.interval]
        , event.url |> Maybe.map (\url -> a [class "event-url", href url] [text url]) |> Maybe.withDefault (text "") 
        ]
