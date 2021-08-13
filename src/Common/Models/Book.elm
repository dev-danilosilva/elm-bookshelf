module Common.Models.Book exposing ( newBook
                                   , isbn
                                   , title
                                   , author
                                   , authors
                                   , publisher
                                   , pubDate
                                   , quantity
                                   , isbnAttr
                                   , titleAttr
                                   , authorsAttr
                                   , publisherAttr
                                   , pubDateAttr
                                   , quantityAttr
                                   )

type alias Book =  { isbn      : Isbn
                   , title     : Title
                   , authors   : List Author
                   , publisher : Maybe Publisher
                   , pubDate   : Maybe PubDate
                   , quantity   : Quantity
                   }

type alias Isbn = String

type alias Title = String

type alias Author = String

type alias Publisher = String

type alias PubDate = String

type alias Quantity = Int

-- Book Builder Api

newBook : Isbn -> Title ->  Book
newBook bookId bookTitle =
    { isbn      = bookId
    , title     = bookTitle
    , authors   = []
    , publisher = Nothing
    , pubDate   = Nothing
    , quantity  = 0
    }

isbn : String -> Book -> Book
isbn bookId book =
    { book | isbn = bookId }

title : String -> Book -> Book
title bookTitle book =
    { book | title = bookTitle }

author : String -> Book -> Book
author bookAuthor book =
    let
        currentAuthors = book.authors
    in
        { book | authors = bookAuthor :: currentAuthors }

authors : List Author -> Book -> Book
authors bookAuthors book =
    { book | authors = bookAuthors }

publisher : String -> Book -> Book
publisher pub book =
    { book | publisher = Just pub }

pubDate : String -> Book -> Book
pubDate pubd book =
    { book | pubDate = Just pubd }

quantity : Int -> Book -> Book
quantity qtt book =
    { book | quantity = qtt }

-- 
get : (Book -> a) -> Book -> a
get prop book =
    prop book

isbnAttribute : Book -> String
isbnAttribute book =
    book.isbn

titleAttribute : Book -> String
titleAttribute book =
    book.title

authorsAttribute : Book -> List String
authorsAttribute book =
    book.authors

publisherAttribute : Book -> String
publisherAttribute book =
    case book.publisher of
       Just pb -> pb
       Nothing -> ""

pubDateAttribute : Book -> String
pubDateAttribute book =
    case book.pubDate of
       Just pd -> pd
       Nothing -> ""

quantityAttribute : Book -> Int
quantityAttribute book =
    book.quantity

-- Get Api

titleAttr : Book -> String
titleAttr = get titleAttribute

isbnAttr : Book -> String
isbnAttr = get isbnAttribute

authorsAttr : Book -> List String
authorsAttr = get authorsAttribute

publisherAttr : Book -> String
publisherAttr = get publisherAttribute

pubDateAttr : Book -> String
pubDateAttr = get pubDateAttribute

quantityAttr : Book -> Int
quantityAttr = get quantityAttribute

