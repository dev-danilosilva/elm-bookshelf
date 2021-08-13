module Pages.Search exposing ( Model
                            , Msg
                            , update
                            , init
                            , view)
                            
import Html exposing ( Html
                     , div
                     , h1
                     , text
                     , button)

import Html.Attributes exposing (class)

import Html.Events exposing (onClick)


type alias Model = String

type alias Msg = String

init : (Model, Cmd Msg)
init = ("Search Before Update", Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg _ =
    (msg, Cmd.none)

view : Model -> Html Msg
view model =
    div [class "section"]
                [ div [ class "container"]
                      [ h1 [class "title"] [text "Search"]
                      , button [onClick "Search After Update"] [text model]]
                ]