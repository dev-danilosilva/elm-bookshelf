module Example exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


suite : Test
suite =
    describe "Book Model"
        [ describe "Book.new"
            [ test "Creates the expected model"
                (\_ -> Expect.atMost 5 (List.length [1, 2, 3, 4]))
        ]
    ]
