module View.Menu exposing ( Msg
                          , Model
                          , view
                          , update
                          , init)

import Html exposing (Html, a, aside, li, p, text, ul)
import Html.Attributes exposing (class)

type Menu = Menu Config

type Msg =
    Clicked

type alias Config =
    {options : List MenuOption}

type alias MenuOption=
    {label  : String}

type alias Model =
    {config : Config}

init : (Model, Cmd Msg)
init =
    ({config = {options = []}}, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update _ model = (model, Cmd.none)

view : Html msg
view =
        aside
            [ class "menu"
            ]
            [ p
                [ class "menu-label"
                ]
                [ text "General" ]
            , ul
                [ class "menu-list"
                ]
                [ li []
                    [ a []
                        [ text "Search" ]
                     ]
                , li []
                    [ a []
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
                    [ a []
                        [ text "Manage Library" ]
                     ]
                , li []
                    [a []
                       [text "Preferences"]
                    ]
                ]
             ]
