module Main exposing (main)

import Html exposing (Html)
import List exposing (foldl)

foldit =
    foldl (::) "" [1,2,3]

--tally xs =
    --foldl
        --(\x ( trues, falses ) ->
            --if x then
                --( trues + 1, falses )
            --else
                --( trues, falses + 1 )
        --)
        --""
        --xs

main : Html msg
main =
    Html.text "Hello, World!"
 
