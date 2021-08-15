module Models.Utils exposing (..)

get : entity -> (entity -> property) ->  property
get  entity property = property entity

