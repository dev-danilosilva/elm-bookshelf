module Main exposing (..)

import Html.Attributes as Attr exposing (autocomplete, class, classList, placeholder, id, value)
import Browser exposing (Document)
import Html exposing (Html, text, div, button, span, h1, input, section, option, select, select)
import Html.Events exposing (onClick, onInput)

main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : () -> (Model, Cmd Msg)
init _ = ({ pageTitle    = pageTitle initialPage
          , page         = initialPage
          , searchState  = initialSearchState
          }, Cmd.none)


defaultTitle : String
defaultTitle = "Library Management"


initialSearchState : SearchState
initialSearchState = SearchState "" "" "" False


initialPage : Page
initialPage = Dashboard


searchByOptions : List SearchByOption
searchByOptions =
    [ SearchByOption "Search By" ""
    , SearchByOption "Author"    "Author"
    , SearchByOption "Title"     "Title"
    , SearchByOption "Imprimpt"  "Imprimpt"
    , SearchByOption "ISBN"      "FormattedKey,RowKey"
    ]

orderByOptions : List SearchByOption
orderByOptions =
    [ SearchByOption "Order By" ""
    , SearchByOption "Author"   "Author"
    , SearchByOption "Title"    "Title"
    ]

pageTitle : Page -> String
pageTitle page =
    defaultTitle ++  case page of
        BookListing -> " | My Books"

        Dashboard   -> " | Dashboard"

        Settings    -> " | Settings"

        AddBook     -> " | Register"

        _           -> ""



type alias Model =
    { pageTitle    : String
    , page         : Page
    , searchState  : SearchState
    }


type Msg
    = StandBy
    | Navigate Page
    | EnterFilter String
    | EnterOrderBy String
    | EnterSearchQuery String


type Page
    = Loading
    | BookListing
    | AddBook
    | Dashboard
    | Settings
    | Login


type alias SearchState =
    { term     : String
    , filter   : String
    , orderBy  : String
    , desc     : Bool
    }

type alias SearchByOption =
    { label : String
    , value : String
    }

type alias Book =
    { title : String
    , author: String
    , editor: String
    , isbn  : String
    , publishYear : Int
    }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StandBy ->
            (model, Cmd.none)

        Navigate page ->
            ({model | page = page, pageTitle = pageTitle page}, Cmd.none)

        EnterSearchQuery q ->
            let
                newSearchTerm : SearchState
                newSearchTerm = SearchState q model.searchState.filter model.searchState.orderBy model.searchState.desc
            in
                ({ model | searchState = newSearchTerm }, Cmd.none)

        EnterFilter filter ->
            let
                newSearchTerm : SearchState
                newSearchTerm = SearchState model.searchState.term filter model.searchState.orderBy model.searchState.desc
            in
                ({ model | searchState = newSearchTerm }, Cmd.none)

        EnterOrderBy orderBy ->
            let
                newSearchTerm : SearchState
                newSearchTerm = SearchState model.searchState.term model.searchState.filter orderBy model.searchState.desc
            in
                ({ model | searchState = newSearchTerm }, Cmd.none)



subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Document Msg
view model =
    { title = model.pageTitle
    , body =
        [ viewMainContainer model ]
    }


viewMainContainer : Model -> Html Msg
viewMainContainer model =
    div [ class "main-container"]
        [ viewSideNav model.page
        , section[] [viewContent model.page]
        ]


viewSideNav : Page -> Html Msg
viewSideNav currPage =
    div [class "sidenav"]
        [ viewNavigationButton "Dashboard" Navigate Dashboard (currPage == Dashboard)
        , viewNavigationButton "My Books" Navigate BookListing (currPage == BookListing)
        , viewNavigationButton "Add Book" Navigate AddBook (currPage == AddBook)
        , viewNavigationButton "Settings" Navigate Settings (currPage == Settings)
        , viewNavigationButton "Logout" Navigate Loading False
        ]


viewNavigationButton : String -> (Page -> Msg) -> Page -> Bool -> Html Msg
viewNavigationButton label msg page active =
    let
        buttonClasses = [ ("button", True)
                        , ("active", active)
                        ]
    in
        div [classList buttonClasses
            , onClick <| msg page]
            [text label]


viewContent : Page -> Html Msg
viewContent page =
    case page of
        BookListing ->
            viewBookListing

        AddBook     ->
            viewAddBook

        Dashboard   ->
            viewDashboard

        Settings    ->
            viewSettings

        Loading     ->
            viewLoading

        Login -> text "Login"


viewBookListing : Html Msg
viewBookListing  =
    div [class "book-search-container"]
        [ viewSearchControls
        , div [class "search-result-container"]
            [text "My Database Results"]
        ]


viewAddBook : Html Msg
viewAddBook =
    div [class "book-search-container"]
        [ viewSearchControls
        , div [class "search-result-container"]
            [ div [class "results"]
                (List.map (\book -> viewBookSearchResult book) bookSearchResults )
            ]
        ]



viewSettings : Html Msg
viewSettings = text "Settings"


viewDashboard : Html Msg
viewDashboard = text "Dashboard"

viewLoading : Html Msg
viewLoading =
    div [class "loading-container"]
     [ div [class "loader"] [] ]

viewSelectOption : SearchByOption -> Html Msg
viewSelectOption sb =  option [value sb.value] [text sb.label]

viewSearchControls : Html Msg
viewSearchControls =
    div [class "search-controls"]
        [ select [class "select", id "search-by", onInput EnterFilter]
            (List.map
                (\item -> viewSelectOption item) searchByOptions)

        , input [class "input large", id "q", onInput EnterSearchQuery, placeholder "Search Term", autocomplete False] []

        , select [class "select", id "order-by", onInput EnterOrderBy]
            (List.map
                (\item -> viewSelectOption item) orderByOptions)
        , div [class "button hoverable"] [text "Search"]
        ]


viewBookSearchResult : Book -> Html Msg
viewBookSearchResult book =
    div [class "result"]
        [ div [] [text <| "> Title  " ++ book.title]
        , div [] [text <| "> Author " ++ book.author]
        , div [] [text <| "> Editor " ++ book.editor]
        , div [] [text <| "> ISBN_  " ++ book.isbn]
        , div [] [text <| "> Published At " ++ String.fromInt book.publishYear]
        , div [class "result-actions"] [text "Actions"]
        ]

-- Mock Data

bookSearchResults : List Book
bookSearchResults =
    [ Book "O Vale do Amanhã" "Carlos João Lima" "A Editora" "978-85-204-2938-9" 1923
    , Book "Carmem Miranda - Uma Biografia" "" "" "978-85-204-2938-9" 2034
    , Book "João e o Pé de Feijão" "" "" "978-85-204-2938-9" 2034
    , Book "Blah Bleh Blih" "GGG" "GGGGGG" "978-85-204-2938-9" 2034
    , Book "KLB - Uma Banda Maneira" "HHHHH" "HHH" "978-85-204-2938-9" 2034
    , Book "Harmonia" "Arnold Schoemberg" "" "978-85-204-2938-9" 2034
    , Book "Blah" "AAA" "A Editora" "978-85-204-2938-9" 2034
    , Book "Bleh" "BBB" "A Editora" "978-85-204-2938-9" 2034
    , Book "Blih" "CCC" "A Editora" "978-85-204-2938-9" 2034
    , Book "Bloh" "DDD" "A Editora" "978-85-204-2938-9" 2034
    , Book "Blue" "EEE" "A Editora" "978-85-204-2938-9" 2034
    , Book "Br" "FFF" "A Editora" "978-85-204-2938-9" 2034
    ]
