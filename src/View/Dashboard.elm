module View.Dashboard exposing (Model
                               ,init)


type alias Model = String

init : (Model, Cmd msg)
init = ("", Cmd.none)