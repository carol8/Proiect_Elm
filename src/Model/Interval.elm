module Model.Interval exposing (Interval, compare, full, length, oneYear, open, view, withDurationMonths, withDurationYears)

import Html exposing (Html, div, p, text)
import Html.Attributes exposing (class)
import Model.Date as Date exposing (Date, Month)
import Model.Util exposing (chainCompare)
import Html.Attributes exposing (start)


type Interval
    = Interval { start : Date, end : Maybe Date }


{-| Create an `Interval` from 2 `Date`s. If the second date is before the first the date, the function will return
`Nothing`. When possible, use the `withDurationMonths` or `withDurationYears` functions.
-}
full : Date -> Date -> Maybe Interval
full start end =
    if Date.compare start end == GT then
        Nothing

    else
        Just <| Interval { start = start, end = Just end }


{-| Create an `Interval` from a start year, start month, and a duration in months.
The start year and month are explicitly required because the duration in months is only specified if the start date
also includes a month.
This function, (assuming positive inputs) by definition, can always return a valid `Interval`.
-}
withDurationMonths : Int -> Month -> Int -> Interval
withDurationMonths startYear startMonth duration =
    let
        start =
            Date.full startYear startMonth

        end =
            Date.offsetMonths duration start
    in
    Interval { start = start, end = Just end }


{-| Create an `Interval` from a start `Date`, and a duration in years. This function, (assuming positive inputs)
by definition, can always return a valid `Interval`.
-}
withDurationYears : Date -> Int -> Interval
withDurationYears start duration =
    let
        end =
            Date.offsetMonths (duration * 12) start
    in
    Interval { start = start, end = Just end }


{-| Create an open `Interval` from a start `Date`. Usually used for creating ongoing events.
-}
open : Date -> Interval
open start =
    Interval { start = start, end = Nothing }


{-| Convenience function to create an `Interval` that represents one year.
-}
oneYear : Int -> Interval
oneYear year =
    withDurationYears (Date.onlyYear year) 1


{-| The length of an Interval, in (years, months)
-}
length : Interval -> Maybe ( Int, Int )
length (Interval interval) =
    interval.end
        |> Maybe.andThen (Date.monthsBetween interval.start)
        |> Maybe.map (\totalMonths -> ( totalMonths // 12, modBy 12 totalMonths ))


{-| Compares two intervals.

Intervals are first compared compare by the `start` field.
If the `start` field is equal, the they are compare by the `end` fields:

  - If both are missing (`Nothing`), the intervals are considered equal
  - If both are present (`Just`), the longer interval is considered greater
  - If only one interval is open (its `end` field is `Nothing`) then it will be considered greater

```
    import Model.Date as Date

    Model.Interval.compare (oneYear 2019) (oneYear 2020) --> LT
    Model.Interval.compare (oneYear 2019) (withDurationYears (Date.onlyYear 2020) 2) --> LT
    Model.Interval.compare (withDurationMonths 2019 Date.Jan 2) (withDurationMonths 2019 Date.Jan 2) --> EQ
    Model.Interval.compare (withDurationMonths 2019 Date.Feb 2) (withDurationMonths 2019 Date.Jan 2) --> GT
    Model.Interval.compare (withDurationMonths 2019 Date.Jan 2) (open (Date.onlyYear 2019)) --> LT
```

-}
compare : Interval -> Interval -> Order
compare (Interval intA) (Interval intB) =
    let
        compareMaybeEnd : Interval -> Interval -> Order
        compareMaybeEnd int1 int2 = 
            case (length int1, length int2) of
                (Just (years1, months1), Just (years2, months2)) -> Basics.compare (years1 * 12 + months1) (years2 * 12 + months2)
                (Just _, _) -> LT
                (_, Just _) -> GT
                (Nothing, Nothing) -> EQ
    in
        chainCompare (compareMaybeEnd (Interval intA) (Interval intB)) (Date.compare intA.start intB.start)
        

view : Interval -> Html msg
view interval =
    let
        (Interval intervalRecord) = interval

        intervalStartContent : Html msg
        intervalStartContent = 
            div [] 
            [ text "Starting in: "
            , intervalRecord.start |> Date.view
            ]

        intervalEndContent : Html msg
        intervalEndContent = 
            div [] 
            [ text "Ending in: "
            , intervalRecord.end |> Maybe.map Date.view |> Maybe.withDefault (text "Ongoing")
            ]

        lengthYears : Int -> String
        lengthYears years = 
            if years /= 0 then (String.fromInt years) ++ " years"
            else ""

        lengthMonths : Int -> String
        lengthMonths months = 
            if months /= 0 then (String.fromInt months) ++ " months"
            else ""

        addComma : Int -> Int -> String
        addComma years months = 
            if years /= 0 && months /= 0 then ", "
            else ""

        intervalLengthContent : Int -> Int ->  Html msg
        intervalLengthContent years months = 
            p [class "interval-length"] [text <| "Duration: " ++ lengthYears years ++ addComma years months ++ lengthMonths months]
    in
        div [class "interval"]
        ([ p [class "interval-start"] [intervalStartContent]
        ,  p [class "interval-end"] [intervalEndContent]]
        ++ (length interval |> Maybe.map(\(years, months) -> [intervalLengthContent years months]) >> Maybe.withDefault [p [] [text "Present"]])
        )
    
