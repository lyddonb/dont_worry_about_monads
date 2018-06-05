module Main exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)

import Components.Hello as Hello


-- APP
main : Program Never Model Msg
main =
  Html.program { init = init
               , view = view
               , update = update
               , subscriptions = subscriptions 
               }


-- MODEL
type alias Model = { helloModel : Hello.Model }

init : ( Model, Cmd Msg )
init = ( { helloModel = Hello.init }, Cmd.none )


-- UPDATE
type Msg = HelloMsg Hello.Msg

--update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
      HelloMsg subMsg ->
          let
              ( updatedHelloModel, helloCmd ) =
                  Hello.update subMsg model.helloModel
          in
              ( { model | helloModel = updatedHelloModel }, Cmd.map HelloMsg helloCmd )


subscriptions : Model -> Sub Msg
subscriptions model = Sub.none


view : Model -> Html Msg
view model =
  div 
      [ class "App" ]
      [ div 
          [ class "App-header" ]
          [ img [ src "static/img/logo.svg", class "App-logo", alt "logo" ] []
          , h2 [] [ text ( "Simple Counter Using Elm" ) ]
          , Html.map HelloMsg (Hello.view model.helloModel)
          ] 
      ]
