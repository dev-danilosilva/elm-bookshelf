module Main exposing (..)

import Browser
import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (class)
import Components.Navbar as Navbar exposing (NavbarConfig, asView, navbar, brandTitle, brandHref)
import Pages.Dashboard as Dashboard
import Components.Menu as MenuComponent
import Pages.Search as Search
import Pages.NotFound as NotFound


main : Program () Model Msg
main = Browser.document
        { init   = init
        , view   = view
        , update = update
        , subscriptions = \_ -> Sub.none}

type Page =
      Dashboard Dashboard.Model
    | Search    Search.Model
    | NotFound  NotFound.Model
    | Loading

type MenuState = MenuState MenuComponent.Model

type NavbarState = NavbarState Navbar.Model

type alias Model =
    { pageTitle   : String
    , currentPage : Page
    , navbarState : NavbarState
    , menuState   : MenuState
    }

type Msg =
      NavbarMsg    Navbar.Msg
    | MenuMsg      MenuComponent.Msg
    | DashboardMsg Dashboard.Msg
    | SearchMsg    Search.Msg
    | NotFoundMsg  NotFound.Msg

init : flags -> (Model, Cmd Msg)
init _ =
    let
        (menuState, _) = MenuComponent.init
        (navBarStatus, _) = Navbar.init navbarConfig
    in
        Tuple.pair
            { pageTitle    = "Bookz - Personal Library Management"
            , currentPage  = navigateTo MenuComponent.DashboardOption
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
                (MenuState subModel) = model.menuState

                (newSubModel, subCmd) = MenuComponent.update subMsg subModel

                newMenuState = MenuState newSubModel

                newPage = navigateTo newSubModel.currentOption
            in
                Tuple.pair
                    {model | menuState = newMenuState
                           , currentPage = newPage}
                    (Cmd.map MenuMsg subCmd)
        
        (NotFoundMsg subMsg, NotFound subModel) ->
            let
                (newSubModel, subCmd) = NotFound.update subMsg subModel

                newPageState = NotFound newSubModel

            in
                Tuple.pair
                    {model | currentPage = newPageState}
                    (Cmd.map NotFoundMsg subCmd)

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
            ({model | currentPage = pageNotFound }, Cmd.none)

view : Model -> Browser.Document Msg
view model =
    { title = model.pageTitle
    , body  = [ navbarView
              , viewContainer viewBody model
              ]
    }

navbarConfig : NavbarConfig
navbarConfig = navbar
                 |> brandTitle "Bookz!"
                 |> brandHref  "https://twitter.com/dev_danilosilva"

navbarView : Html Msg
navbarView = navbarConfig
                |> asView
                |> withMessage NavbarMsg

viewContainer : (Page -> Html Msg) -> Model -> Html Msg
viewContainer bodyFn model =
    div [ class ""]
        [ div [class "columns"]
              [ div [class "column is-2"]
                    [MenuComponent.view |> withMessage MenuMsg]
              , div [class "column is-10"]
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

        NotFound model ->
            NotFound.view model |> withMessage NotFoundMsg
        
        Search model ->
            Search.view model |> withMessage SearchMsg

        Dashboard model ->
            Dashboard.view model |> withMessage DashboardMsg

withMessage : (msg -> Msg) -> Html msg -> Html Msg
withMessage fn =
    Html.map fn

navigateTo : MenuComponent.MenuOption -> Page
navigateTo option =
    case option of
        MenuComponent.DashboardOption ->
            let
                (pageState, _) = Dashboard.init
            in
                Dashboard pageState

        MenuComponent.SearchOption ->
            let
                (pageState, _) = Search.init
            in
                Search pageState
        
        MenuComponent.ManageLibraryOption ->
            pageNotFound

        MenuComponent.PreferencesOption ->
            pageNotFound

pageNotFound : Page
pageNotFound =
    let
        (pageState, _) = NotFound.init
    in
        NotFound pageState
