module View.Menu exposing ( Msg
                          , Model
                          , view
                          , update
                          , init)

import Html exposing (Html, a, aside, li, p, text, ul)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)


type alias Msg = MenuOption

type MenuOption
    = SearchOption
    | DashboardOption
    | ManageLibraryOption
    | PreferencesOption

type alias Model =
    {currentOption : MenuOption}

init : (Model, Cmd Msg)
init =
    ({currentOption = DashboardOption}, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    let
        chosenOption : MenuOption
        chosenOption = msg
    in
        case msg of
            SearchOption ->
                ({model | currentOption = chosenOption}, Cmd.none)

            DashboardOption ->
                ({model | currentOption = chosenOption}, Cmd.none)

            ManageLibraryOption ->
                ({model | currentOption = chosenOption}, Cmd.none)

            PreferencesOption ->
                ({model | currentOption = chosenOption}, Cmd.none)

view : Html Msg
view =
        aside
            [ class "menu pl-3 pt-3"
            ]
            [ p
                [ class "menu-label"
                ]
                [ text "General" ]
            , ul
                [ class "menu-list"
                ]
                [ li []
                    [ a [onClick SearchOption]
                        [ text "Search" ]
                     ]
                , li []
                    [ a [onClick DashboardOption]
                        [ text "Dashboard" ]
                     ]
                 ]
            , p
                [ class "menu-label"
                ]
                [ text "Settings" ]
            , ul
                [ class "menu-list"
                ]
                [ li []
                    [ a [onClick ManageLibraryOption]
                        [ text "Manage Library" ]
                     ]
                , li []
                    [ a [onClick PreferencesOption]
                          [text "Preferences"]
                    ]
                ]
             ]
