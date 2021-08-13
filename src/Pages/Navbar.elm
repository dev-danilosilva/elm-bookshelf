module Pages.Navbar exposing ( Theme(..)
                             , Model
                             , Msg
                             , NavbarConfig
                             , navbar
                             , brandTitle
                             , brandHref
                             , brandLink
                             , theme
                             , init
                             , update
                             , asView)

import Html.Events exposing (onClick)
import Html exposing (Html, a, div, h1, nav, text)
import Html.Attributes exposing (class, href)


type Msg =
      SwitchTheme Theme
    | GoToTwitter

type Theme =
      Light
    | Dark

type alias Config =
    { brandTitle : String
    , brandLink  : Bool
    , brandHref  : Maybe String
    , theme      : Theme
    }

type NavbarConfig = NavbarConfig Config

type alias Model =
    {config : NavbarConfig}

defaultConfig : Config
defaultConfig =
    { brandTitle = ""
    , brandLink = False
    , brandHref = Nothing
    , theme     = Light
    }

navbar : NavbarConfig
navbar = NavbarConfig defaultConfig

brandTitle : String -> NavbarConfig -> NavbarConfig
brandTitle title (NavbarConfig config) =
    NavbarConfig {config | brandTitle = title}

brandLink : Bool -> NavbarConfig -> NavbarConfig
brandLink blink (NavbarConfig config) =
    NavbarConfig {config | brandLink = blink}

brandHref : String -> NavbarConfig -> NavbarConfig
brandHref href (NavbarConfig config) =
    let
        wrapped = if String.isEmpty href then
                    Nothing
                  else
                    Just href
    in
        NavbarConfig {config | brandHref = wrapped}

theme : Theme -> NavbarConfig -> NavbarConfig
theme t (NavbarConfig config) = NavbarConfig {config | theme = t}

getConfig : NavbarConfig -> Config
getConfig (NavbarConfig config) = config


init : NavbarConfig -> (Model, Cmd Msg)
init config =
    ({config = config}, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        SwitchTheme newTheme ->
            let
                currConfig = getConfig model.config
                newConfig = NavbarConfig {currConfig | theme = newTheme}
            in
                 ({model | config = newConfig}, Cmd.none)
        GoToTwitter ->
            (model, Cmd.none)

asView : NavbarConfig -> Html Msg
asView (NavbarConfig config) =
    let
        brand_title = config.brandTitle
        brand_href  = Maybe.withDefault "" config.brandHref

        brandFn = if config.brandLink then
                    a
                  else
                    div
    in
        nav
            [ class "navbar is-dark" ]
            [ div
                [ class "navbar-brand"
                ]
                [ brandFn
                    [ class "navbar-item"
                    , href brand_href
                    ]
                    [ h1 [class "title has-text-light"] [text brand_title]
                    ]
                 ]
             , div [class "navbar-end"]
                   [ div [ class "navbar-item"]
                         [ div [class "buttons"]
                               [ div [ class "button is-link"
                                     , href "https://www.twitter.com"
                                     , onClick GoToTwitter]
                                     [text "Twitter"]
                               , a [class "button is-info", href "https://www.linkedin.com"]
                                   [text "LinkedIn"]
                               ]
                         ]
                   ]
             ]


