module Components.Navbar.View exposing (ViewConfig, renderWith)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias ViewConfig =
    { brandTitle   : String
    , brandHref    : String
    }


renderWith : ViewConfig -> Html msg
renderWith viewConfig =
    nav
        [ class "navbar is-dark" ]
        [ div
            [ class "navbar-brand"
            ]
            [ a
                [ class "navbar-item"
                , href viewConfig.brandHref
                ]
                [ h1 [class "title has-text-light"] [text viewConfig.brandTitle]
                ]
                ]
            , div [class "navbar-end"]
                [ div [ class "navbar-item"] []
                ]
            ]