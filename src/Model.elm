module Model exposing (..)

import Html exposing (b, div, p, text)
import Model.Date as Date
import Model.Event as Event exposing (Event)
import Model.Event.Category exposing (EventCategory(..), SelectedEventCategories, allSelected)
import Model.Interval as Interval
import Model.PersonalDetails exposing (DetailWithName, PersonalDetails)
import Model.Repo exposing (Repo)


type alias Model =
    { personalDetails : PersonalDetails
    , events : List Event
    , selectedEventCategories : SelectedEventCategories
    , repos : List Repo
    }


academicEvents : List Event
academicEvents =
    [ { title = "Academic event 1"
      , interval = Interval.withDurationYears (Date.onlyYear 2016) 4
      , description = p [] [ text "I obtained ", b [] [ text "very" ], text " good grades." ]
      , category = Academic
      , url = Nothing
      , tags = []
      , important = False
      }
    , { title = "Academic event 2"
      , interval = Interval.withDurationYears (Date.onlyYear 2020) 2
      , description = div [] []
      , category = Academic
      , url = Nothing
      , tags = []
      , important = False
      }
    ]


workEvents : List Event
workEvents =
    [ { title = "DATS Evenimente"
      , interval = Interval.withDurationMonths 2022 Date.Feb 6
      , description = text "DATS Evenimente is an event display app for the DATS events"
      , category = Work
      , url = Just "https://github.com/carol8/DATS_Evenimente"
      , tags = ["Android"]
      , important = True
      }
    , { title = "Bosch"
      , interval = Interval.withDurationMonths 2022 Date.Jul 3
      , description = text "Working Student in the iRWS x DevOps teams"
      , category = Work
      , url = Nothing
      , tags = ["Bosch"]
      , important = True
      }
    ]


projectEvens : List Event
projectEvens =
    [ { title = "NX Ball"
      , interval = Interval.withDurationMonths 2021 Date.Mar 3
      , description = text "A copy of the famous Atari Breakout, made in x86 ASM"
      , category = Project
      , url = Just "https://github.com/carol8/NX_BALL"
      , tags = ["ASM", "Game", "Windows", "x86"]
      , important = False
      }
    , { title = "DATS Evenimente"
      , interval = Interval.withDurationMonths 2022 Date.Feb 6
      , description = text "DATS Evenimente is an event display app for the DATS events"
      , category = Project
      , url = Just "https://github.com/carol8/DATS_Evenimente"
      , tags = ["Android"]
      , important = True
      }
    , { title = "Elm Personal Webpage"
      , interval = Interval.open (Date.full 2022 Date.Nov)
      , description = text "A personal webpage made using Elm"
      , category = Project
      , url = Nothing
      , tags = []
      , important = False
      }
    ]


personalDetails : PersonalDetails
personalDetails =
    { name = "Cristian Budiul"
    , intro = "I like computers"
    , contacts = [ DetailWithName "email" "cristib_2002@yahoo.com" ]
    , socials = [ DetailWithName "github" "https://github.com/carol8" ]
    , repo_addr = "https://api.github.com/users/carol8/repos"
    }


initModel : Model
initModel =
    { personalDetails = personalDetails
    , events = Event.sortByInterval <| academicEvents ++ workEvents ++ projectEvens
    , selectedEventCategories = allSelected
    , repos = []
    }
