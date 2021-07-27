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

type NavbarState = NavbarState Navbar.Model

type alias Model =
    { pageTitle   : String
    , currentPage : Page
    , navbarState : NavbarState
    , menuState   : MenuState
    }

type Msg =
      NavbarMsg Navbar.Msg
    | MenuMsg   Menu.Msg

init : flags -> (Model, Cmd Msg)
init _ =
    let
        (menuState, _) = Menu.init
        (navBarStatus, _) = Navbar.init (navbar
                                            |> brandTitle "Bookz!"
                                            |> brandLink  True
                                            |> brandHref  "https://twitter.com/dev_danilosilva")
    in
        Tuple.pair
            { pageTitle    = "Bookz"
            , currentPage  = Loading
            , navbarState  = NavbarState navBarStatus
            , menuState    = MenuState menuState
            }
            Cmd.none

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case (msg, model.currentPage) of
        (NavbarMsg subMsg, _) ->
            let
                subModel           = case model.navbarState of
                                          NavbarState state -> state

                (newSubModel, subCmd) = Navbar.update subMsg subModel

                newState= NavbarState newSubModel
            in
                Tuple.pair
                    {model | navbarState = newState}
                    (Cmd.map NavbarMsg subCmd)

        (MenuMsg subMsg, _) ->
            let
                subModel = case model.menuState of
                                MenuState state -> state

                (newSubModel, subCmd) = Menu.update subMsg subModel

                newState = MenuState newSubModel
            in
                Tuple.pair
                    {model | menuState = newState}
                    (Cmd.map MenuMsg subCmd)

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
              , viewContainer viewBody model
              ]
    }

viewContainer : (Page -> Html Msg) -> Model -> Html Msg
viewContainer bodyFn model =
    div [ class ""]
        [ div [class "columns"]
              [ div [class "column is-one-fifth"]
                    [Menu.view |> withMessage MenuMsg]
              , div [class "column"]
                    [bodyFn model.currentPage]
              ]
        ]

viewBody : Page -> Html Msg
viewBody currentPage =
    case currentPage of
        Loading ->
            div [class "section"]
                [div [class "container"]
                     [h1 [class "title"] [text "Loading..."]]
                ]

        Dashboard _ ->
            div [class "section"]
                            [div [class "container"]
                                 [h1 [class "title"] [text "Dashboard"]]
                            ]


withMessage : (msg -> Msg) -> Html msg -> Html Msg
withMessage fn =
    Html.map fn

