module Main exposing (..)
import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Keyed as Keyed
import Html.Lazy exposing (lazy)
import Html.Attributes exposing (..)
import Url

-- main --

main : Program () Model Msg
main =
  Browser.application
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlChange = UrlChanged
    , onUrlRequest = LinkClicked
    }

-- init --

type alias Model = 
  { key : Nav.Key
  , url : Url.Url
  }

init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
  ( Model key url, Cmd.none )

-- msg --

type Msg
  = LinkClicked Browser.UrlRequest
  | UrlChanged Url.Url

-- update --

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    LinkClicked urlRequest ->
      case urlRequest of
        Browser.Internal url ->
          ( model, Nav.pushUrl model.key ( Url.toString url ) )
        Browser.External href ->
          ( model, Nav.load href )

    UrlChanged url ->
      ( { model | url = url }
      , Cmd.none
      )

-- subscriptions --

subscriptions : Model -> Sub Msg
subscriptions _ = 
  Sub.none

-- view --

view : Model -> Browser.Document Msg
view model = 
  { title = "beaver-felix's url interceptor"
  , body = 
    [ text "Current url > "
    , b [] [ text ( Url.toString model.url ) ]
    , ul []
      [ viewlink "/home"
      , viewlink "/profile"
      , viewlink "/blog"
      ]
    ]
  }

viewlink : String -> Html Msg
viewlink path =
  li [] [ a [ href path ] [ text path ] ]