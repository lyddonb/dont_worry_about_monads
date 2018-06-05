module Components.Hello exposing (..)

import Html exposing (..)
import Html.Events exposing ( onClick )


-- MODEL
type alias Model = Int

init : Model
init = 0


-- UPDATE
type Msg = Increment | Decrement

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Increment -> ( model + 1, Cmd.none )
    Decrement -> ( model - 1, Cmd.none )


-- hello component
view : Model -> Html Msg
view model =
  div
    []
    [ h2 [ ] [ text (toString model ) ]
    , button [ onClick Decrement ] [ text "-" ]
    , button [ onClick Increment ] [ text "+" ]
    ]
