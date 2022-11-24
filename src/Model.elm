module Model exposing (..)

import Html exposing (p, text)
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
    [ { title = "High school"
      , interval = Interval.withDurationMonths 2016 Date.Sep 45
      , description = p [] [ text "I was a member of the RobotX Hunedoara, that participated in many competitions such as First Tech Challange or First Global Challenge"]
      , category = Academic
      , url = Nothing
      , tags = []
      , important = False
      }
    , { title = "University"
      , interval = Interval.open (Date.full 2020 Date.Sep)
      , description = p [] [text "Trying to learn as much as I can"]
      , category = Academic
      , url = Nothing
      , tags = []
      , important = True
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


projectEvents : List Event
projectEvents =
    [ { title = "NX Ball"
      , interval = Interval.withDurationMonths 2021 Date.Mar 3
      , description = text "A copy of the famous Atari Breakout, made in x86 ASM"
      , category = Project
      , url = Just "https://github.com/carol8/NX_BALL"
      , tags = ["ASM", "Game", "Windows", "x86"]
      , important = False
      }
    , { title = "Elm Personal Webpage"
      , interval = Interval.open (Date.full 2022 Date.Nov)
      , description = text "A personal webpage made using Elm"
      , category = Project
      , url = Just "https://github.com/carol8/Proiect_Elm"
      , tags = ["Elm", "Wepbage"]
      , important = False
      }
    ]


awardEvents : List Event
awardEvents = 
  [ { title = "First Global Challange 2018 - international robotics olympiad"
    , interval = Interval.withDurationMonths 2018 Date.Jun 3
    , description = text "We won almost every category - first place in six categories"
    , category = Award
    , url = Just "https://first.global/archive/fgc-2018/"
    , tags = ["International", "Robotics"]
    , important = True
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
    , events = Event.sortByInterval <| academicEvents ++ workEvents ++ projectEvents ++ awardEvents
    , selectedEventCategories = allSelected
    , repos = []
    }
