module Pages.NotFound exposing ( Model
                               , Msg
                               , init
                               , update
                               , view
                               )

import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (class)

type alias Model =
    {pageTitle : String}

type alias Msg = String

init : (Model, Cmd Msg)
init = ({pageTitle = "Page Not Found"}, Cmd.none)

update : Msg -> Model ->  ( Model, Cmd Msg )
update _ model =
    (model, Cmd.none)

view : Model -> Html Msg
view model =
    div [class "section"]
        [div [class "container"]
                [h1 [class "title"] [text model.pageTitle]]
        ]