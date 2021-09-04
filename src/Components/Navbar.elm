module Components.Navbar exposing   ( Model
                                    , Msg
                                    , NavbarConfig
                                    , navbar
                                    , brandTitle
                                    , brandHref
                                    , theme
                                    , init
                                    , update
                                    , asView)

import Components.Navbar.View as View
import Common.Theme as Theme
import Html exposing (Html)


type Msg =
      SwitchTheme Theme.Theme
    | GoToTwitter


type alias Config =
    { brandTitle : String
    , brandHref  : Maybe String
    , theme      : Theme.Theme
    }

type NavbarConfig = NavbarConfig Config

type alias Model =
    {config : NavbarConfig}

defaultConfig : Config
defaultConfig =
    { brandTitle = ""
    , brandHref = Nothing
    , theme     = Theme.Light
    }

navbar : NavbarConfig
navbar = NavbarConfig defaultConfig

brandTitle : String -> NavbarConfig -> NavbarConfig
brandTitle title (NavbarConfig config) =
    NavbarConfig {config | brandTitle = title}


brandHref : String -> NavbarConfig -> NavbarConfig
brandHref href (NavbarConfig config) =
    let
        wrapped = if String.isEmpty href then
                    Nothing
                  else
                    Just href
    in
        NavbarConfig {config | brandHref = wrapped}

theme : Theme.Theme -> NavbarConfig -> NavbarConfig
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
        title = config.brandTitle
        href  = Maybe.withDefault "" config.brandHref

    in
        View.renderWith
            { brandTitle   = title
            , brandHref    = href}
        


