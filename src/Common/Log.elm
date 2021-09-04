port module Common.Log exposing (..)


port info : String -> Cmd msg

port error : String -> Cmd msg