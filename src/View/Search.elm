module View.Search exposing ( Model
                            , Msg
                            , update
                            , init)


type alias Model = String

type alias Msg = String

init : (Model, Cmd Msg)
init = ("", Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update _ model =
    (model, Cmd.none)