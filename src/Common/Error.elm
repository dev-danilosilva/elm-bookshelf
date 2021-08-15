module Common.Error exposing ( ErrorInfo
                             , errorInfo
                             , fromResult
                             , invalidEntity
                             , invalidInput
                             , badRequest
                             )


type alias ErrorType = String

type alias ErrorInfo a =
    { error : String
    , data  : a
    }

errorInfo : ErrorType -> a -> ErrorInfo a
errorInfo errorType data =
    { error = errorType
    , data = data}

fromResult : errorData ->  Result String a -> Maybe (ErrorInfo errorData)
fromResult data result =
    case result of
        Ok _ -> Nothing
        Err err -> Just <| errorInfo err data

-- Errors

invalidEntity : data -> ErrorInfo data
invalidEntity = errorInfo "Invalid Entity"

invalidInput : data -> ErrorInfo data
invalidInput = errorInfo "Invalid Input"

badRequest : data -> ErrorInfo data
badRequest = errorInfo "Bad Request"


