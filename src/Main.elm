module Main exposing (..)

import Browser
import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (class)
import Pages.Navbar as Navbar exposing (asView, navbar, brandTitle, brandLink, brandHref)
import Pages.Dashboard  as Dashboard
import Pages.Menu as Menu
import Pages.Search as Search

main : Program () Model Msg
main = Browser.document
        { init   = init
        , view   = view
        , update = update
        , subscriptions = \_ -> Sub.none}

type Page =
      Dashboard Dashboard.Model
    | Search    Search.Model
    | NotFound  String
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
    | DashboardMsg Dashboard.Msg
    | SearchMsg Search.Msg

init : flags -> (Model, Cmd Msg)
init _ =
    let
        (menuState, _) = Menu.init
        (navBarStatus, _) = Navbar.init (navbar
                                            |> brandTitle "Bookz"
                                            |> brandLink  True
                                            |> brandHref  "https://twitter.com/dev_danilosilva")
    in
        Tuple.pair
            { pageTitle    = "Bookz - Personal Library Management"
            , currentPage  = navigateTo Menu.DashboardOption
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

                newMenuState = MenuState newSubModel

                newPage = navigateTo newSubModel.currentOption
            in
                Tuple.pair
                    {model | menuState = newMenuState
                           , currentPage = newPage}
                    (Cmd.map MenuMsg subCmd)
        
        (DashboardMsg subMsg, Dashboard subModel) ->
            let
                (newSubModel, subCmd) = Dashboard.update subMsg subModel

                newPageState = Dashboard newSubModel

            in
                Tuple.pair
                    {model | currentPage = newPageState}
                    (Cmd.map DashboardMsg subCmd)
        
        (SearchMsg subMsg, Search subModel) ->
            let
                (newSubModel, subCmd) = Search.update subMsg subModel

                newPageState = Search newSubModel
            in
                Tuple.pair
                    {model | currentPage = newPageState}
                    (Cmd.map SearchMsg subCmd)
        _ ->
            ({model | currentPage = NotFound ""}, Cmd.none)

navbarView : Html Msg
navbarView = navbar
                |> brandTitle "Bookz!"
                |> brandLink  True
                |> brandHref "/"
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
        NotFound pageTitle ->
            div [class "section"]
                [div [class "container"]
                     [h1 [class "title"] [text <| String.append pageTitle " Page Not Found"]]
                ]
        
        Search model ->
            Search.view model |> withMessage SearchMsg

        Dashboard model ->
            Dashboard.view model |> withMessage DashboardMsg

withMessage : (msg -> Msg) -> Html msg -> Html Msg
withMessage fn =
    Html.map fn

navigateTo : Menu.MenuOption -> Page
navigateTo option =
    case option of
        Menu.DashboardOption ->
            let
                (pageState, _) = Dashboard.init
            in
                Dashboard pageState

        Menu.SearchOption ->
            let
                (pageState, _) = Search.init
            in
                Search pageState
        
        Menu.ManageLibraryOption ->
            NotFound "Library Management"

        Menu.PreferencesOption ->
            NotFound "Preferences"
