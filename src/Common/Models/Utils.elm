module Common.Models.Utils exposing (..)

get : entity -> (entity -> property) -> property
get entity propExtractor=
    propExtractor entity

