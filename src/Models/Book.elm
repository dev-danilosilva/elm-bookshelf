module Models.Book exposing
    ( Book
    , Author(..)
    , author
    , authors
    , isbn
    , newBook
    , pubDate
    , publisher
    , quantity
    , title
    , validate
    , withAuthor
    , withAuthors
    , withIsbn
    , withPubDate
    , withPublisher
    , withQuantity
    , withTitle
    )

import Common.Error as Error


type alias Book =
    { isbn : Maybe Isbn
    , title : Maybe Title
    , authors : List Author
    , publisher : Maybe Publisher
    , pubDate : Maybe PubDate
    , quantity : Quantity
    }


type Isbn
    = Isbn String


type Title
    = Title String


type Author
    = Author String


type Publisher
    = Publisher String


type PubDate
    = PubDate String


type alias Quantity =
    Int



-- Book Builder Api


newBook : Book
newBook =
    { isbn = Nothing
    , title = Nothing
    , authors = []
    , publisher = Nothing
    , pubDate = Nothing
    , quantity = 0
    }


withIsbn : String -> Book -> Book
withIsbn bookId book =
    { book
        | isbn =
            case bookId of
                "" ->
                    Nothing

                _ ->
                    Just <| Isbn bookId
    }


withTitle : String -> Book -> Book
withTitle bookTitle book =
    { book
        | title =
            case bookTitle of
                "" ->
                    Nothing

                _ ->
                    Just <| Title bookTitle
    }


withAuthor : String -> Book -> Book
withAuthor bookAuthor book =
    let
        currentAuthors =
            book.authors
    in
    { book | authors = Author bookAuthor :: currentAuthors }


withAuthors : List Author -> Book -> Book
withAuthors bookAuthors book =
    { book | authors = bookAuthors }


withPublisher : String -> Book -> Book
withPublisher pub book =
    { book | publisher = Just <| Publisher pub }


withPubDate : String -> Book -> Book
withPubDate pubd book =
    { book | pubDate = Just <| PubDate pubd }


withQuantity : Int -> Book -> Book
withQuantity qtt book =
    { book | quantity = qtt }



-- Property Extractors


isbn : Book -> Maybe String
isbn book =
    let
        valueExtractor =
            \(Isbn i) -> Just i
    in
    Maybe.andThen valueExtractor book.isbn


title : Book -> Maybe String
title book =
    let
        valueExtractor =
            \(Title i) -> Just i
    in
    Maybe.andThen valueExtractor book.title

author : Author -> String
author (Author a) = a

authors : Book -> List String
authors book =
    List.map author book.authors


publisher : Book -> Maybe String
publisher book =
    Maybe.andThen (\(Publisher p) -> Just p) book.publisher


pubDate : Book -> Maybe String
pubDate book =
    Maybe.andThen (\(PubDate pd) -> Just pd) book.pubDate


quantity : Book -> Quantity
quantity book =
    book.quantity



-- TODO Refactor this function


validate : Book -> Result (Error.ErrorInfo { missingFields : List String }) Book
validate book =
    Debug.todo "Implement this function"
