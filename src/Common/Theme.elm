module Common.Theme exposing (Theme(..), getColors, primary, secondary, contrast)


type Theme = Light | Dark

getColors : Theme -> {primary : String, secondary : String, contrast : String}
getColors theme =
    case theme of
       Dark ->
        { primary   = "#EDEDED"
        , secondary = "#454545"
        , contrast  = "#E345F2"}
      
       Light ->
        { primary   = "#000000"
        , secondary = "#EDEDED"
        , contrast =  "#345611"}


primary : Theme -> String
primary = getColors >> .primary

secondary : Theme -> String
secondary = getColors >> .secondary

contrast : Theme -> String
contrast = getColors >> .contrast
