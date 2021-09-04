port module Pages.Dashboard exposing
    ( Model
    , Msg
    , init
    , update
    , view
    , fakeBook
    , fakeBookEncoder
    )

import Html exposing (Html, button, div, h1, p, text, ul, li)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Http
import Json.Encode as Encode
import Json.Decode as Decode


port sendData : String -> Cmd msg

type alias FakeBookSchema  =
    { isbn : String
    , title : String
    , publisher : String
    , pubDate : String
    , authors : String
    , quantity: String}

type alias FakeBook =
    { token : String
    , data  : FakeBookSchema}

fakeBookSchema : FakeBookSchema
fakeBookSchema =
    { isbn = "stringAlphaNum"
    , title = "productName"
    , publisher = "companyName"
    , pubDate = "date"
    , authors = "name" -- "functionArray|3|name"
    , quantity = "stringDigits"}

fakeBook : FakeBook
fakeBook = 
    {token = "MPS-yu0ZOs5VcnOOiW-_ug"
    ,data = fakeBookSchema}

fakeBookSchemaEncoder : FakeBookSchema -> Encode.Value
fakeBookSchemaEncoder s =
    Encode.object
        [("isbn", Encode.string s.isbn)
        ,("title", Encode.string s.title)
        ,("authors",Encode.string s.authors)
        ,("publisher", Encode.string s.publisher)
        ,("pubDate", Encode.string s.pubDate)
        ,("quantity", Encode.string s.quantity)
        ]

fakeBookEncoder : FakeBook -> Encode.Value
fakeBookEncoder fb =
    Encode.object
        [("token", Encode.string fb.token)
        ,("data", fakeBookSchemaEncoder fb.data)]

bookDecoder : Decode.Decoder FakeBookSchema
bookDecoder =
    Decode.map6 FakeBookSchema
        (Decode.field "isbn" Decode.string)
        (Decode.field "title" Decode.string)
        (Decode.field "authors" Decode.string)
        (Decode.field "publisher" Decode.string)
        (Decode.field "pubDate" Decode.string)
        (Decode.field "quantity" Decode.string)


type Msg
    = GotText (Result Http.Error String)
    | GotJson (Result Http.Error FakeBookSchema)
    | FetchJsonAndDecode
    | Clicked


type Model
    = Failure
    | Loading
    | Success String
    | SuccessfullyDecoded FakeBookSchema
    | StandBy


init : ( Model, Cmd Msg )
init =
    ( StandBy
    , Cmd.none
    )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        Clicked ->
            ( Loading
            , Http.get
                { url = "https://elm-lang.org/assets/public-opinion.txt"
                , expect = Http.expectString GotText 
                }
            )
        
        FetchJsonAndDecode ->
            ( Loading
            , Http.post
                { url  = "https://app.fakejson.com/q"
                , body = Http.jsonBody (fakeBookEncoder fakeBook)
                , expect =  Http.expectJson GotJson bookDecoder})
        
        GotJson result ->
            case result of
                Ok fbSchema ->
                    (SuccessfullyDecoded fbSchema, sendData "Hello JS, Aqui quem fala é ela, a Elm application")
                Err error ->
                    let
                        _ = Debug.log "Error" error
                    in
                        (Failure, Cmd.none)

        GotText result ->
            case result of
                Ok text ->
                    ( Success text, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "section" ]
        [ div [ class "container" ]
            [ h1 [ class "title" ] [ text "Dashboard" ]
            , button [ onClick Clicked ] [ text "Buscar .txt" ]
            , button [ onClick FetchJsonAndDecode ] [text "Buscar .json"]
            , div []
                [ p []
                    [ case model of
                        Failure ->
                            text "Erro na Requisição"

                        Loading ->
                            text "Carregando..."

                        Success txt ->
                            text <| Debug.log "Books" txt
                        
                        SuccessfullyDecoded fb ->
                            let
                                _ = Debug.log "Book" fb
                            in
                                div []
                                    [ul []
                                        [li [] [text fb.title]
                                        ,li [] [text fb.authors]
                                        ,li [] [text fb.publisher]]]

                        StandBy ->
                            text ""
                    ]
                ]
            ]
        ]


