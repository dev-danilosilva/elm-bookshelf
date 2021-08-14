module Common.Models.Book exposing ( newBook
                                   , isbn
                                   , title
                                   , authors
                                   , publisher
                                   , pubDate
                                   , quantity
                                   , withIsbn
                                   , withTitle
                                   , withAuthor
                                   , withAuthors
                                   , withPublisher
                                   , withPubDate
                                   , withQuantity
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

withIsbn : String -> Book -> Book
withIsbn bookId book =
    { book | isbn = bookId }

withTitle : String -> Book -> Book
withTitle bookTitle book =
    { book | title = bookTitle }

withAuthor : String -> Book -> Book
withAuthor bookAuthor book =
    let
        currentAuthors = book.authors
    in
        { book | authors = bookAuthor :: currentAuthors }

withAuthors : List Author -> Book -> Book
withAuthors bookAuthors book =
    { book | authors = bookAuthors }

withPublisher : String -> Book -> Book
withPublisher pub book =
    { book | publisher = Just pub }

withPubDate : String -> Book -> Book
withPubDate pubd book =
    { book | pubDate = Just pubd }

withQuantity : Int -> Book -> Book
withQuantity qtt book =
    { book | quantity = qtt }

-- Property Extractors

isbn : Book -> String
isbn book =
    book.isbn

title : Book -> String
title book =
    book.title

authors : Book -> List String
authors book =
    book.authors

publisher : Book -> String
publisher book =
    case book.publisher of
       Just pb -> pb
       Nothing -> ""

pubDate : Book -> String
pubDate book =
    case book.pubDate of
       Just pd -> pd
       Nothing -> ""

quantity : Book -> Int
quantity book =
    book.quantity
