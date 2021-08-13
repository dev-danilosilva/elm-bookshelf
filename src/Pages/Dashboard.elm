module Pages.Dashboard exposing ( Model
                                , Msg
                                , init
                                , update
                                , view
                                )
import Html exposing (Html, div, h1, text, button)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)

type alias Msg = String

type alias Model = String

init : (Model, Cmd msg)
init = ("Dashboard before update", Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg _ =
    (msg, Cmd.none)

view : Model -> Html Msg
view model =
    div [class "section"]
                [div [ class "container"]
                        [ h1 [class "title"] [text model]
                        , button [onClick "Dashboard after update"] [text "Mudar Texto"]]
                ]