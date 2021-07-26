module Main exposing (..)

import Browser
import Html exposing (Html, a, aside, div, h1, li, p, text, ul)
import Html.Attributes exposing (class)
import View.Navbar as Navbar exposing (asView, navbar, brandTitle, brandLink, brandHref)
import View.Dashboard  as Dashboard
import View.Menu as Menu

main : Program () Model Msg
main = Browser.document
        { init   = init
        , view   = view
        , update = update
        , subscriptions = \_ -> Sub.none}

type Page =
      Dashboard Dashboard.Model
    | Loading

type MenuState = MenuState Menu.Model -- TODO Think about the menu model

type alias Model =
    { pageTitle   : String
    , currentPage : Page
    , menuState   : MenuState
    }

type Msg =
      Clear
    | NewStatus String
    | NavbarMsg Navbar.Msg
    | MenuMsg   Menu.Msg

init : flags -> (Model, Cmd Msg)
init _ =
    Tuple.pair
        { pageTitle    = "Bookz"
        , currentPage  = Dashboard "Sample Model"
        , menuState    = MenuState Menu.init -- Change the way the initial state is fatched
        }
        Cmd.none

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        NewStatus s -> Tuple.pair model Cmd.none
        Clear       -> Tuple.pair {model | pageTitle = ""} Cmd.none
        -- Call the submodel update function
        NavbarMsg _ -> (model, Cmd.none)
        MenuMsg   _ -> (model, Cmd.none)


navbarView : Html Msg
navbarView = navbar
                |> brandTitle "Bookz!"
                |> brandLink  True
                |> brandHref  "https://twitter.com/dev_danilosilva"
                |> asView
                |> withMessage NavbarMsg

view : Model -> Browser.Document Msg
view model =
    { title = model.pageTitle
    , body  = [ navbarView
              , mainView model
              ]
    }

mainView : Model -> Html Msg
mainView model =
    div [ class ""]
        [ div [class "columns"]
              [ div [class "column is-one-fifth"]
                    [Menu.view |> withMessage MenuMsg]
              , div [class "column"]
                    [h1 [] [text model.pageTitle]]
              ]
        ]

withMessage : (msg -> Msg) -> Html msg -> Html Msg
withMessage fn =
    Html.map fn






