module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Html
import Html.Attributes
import Url
import Url.Parser as Parser exposing (Parser, (</>), custom, fragment, map, oneOf, s, top)

-- optim --

-- import Html.Keyed as Keyed
-- import Html.Lazy exposing (lazy)

-- page --

import Page.Blog
import Page.Home
import Page.Map
import Page.Policy
import Page.Profile
import Page.Project

-- main --

main : Program () Model Msg
main =
  Browser.application
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlRequest = LinkClicked
    , onUrlChange = UrlChanged
    }

type alias Model = 
  { key  : Nav.Key
  , page : Page
  }

type Page
  = NotFound Data -- todo --
  | Blog Page.Blog.Model
  | Home Page.Home.Model
  | Map Page.Map.Model
  | Policy Page.Policy.Model
  | Profile Page.Profile.Model
  | Project Page.Project.Model

-- init --

init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
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

-- view --

view : Model -> Browser.Document Msg
view model = 
  { title = "Beaver Felix"
  , body = 
    [ text "Current url > "
    , b [] [ text ( Url.toString model.url ) ]
    , ul []
      [ viewlink "/home"
      , viewlink "/blog"
      , viewlink "/policy"
      , viewlink "/profile"
      , viewlink "/project"
      , viewlink "/site-map"
      ]
    ]
  }

viewlink : String -> Html Msg
viewlink path =
  li [] [ a [ href path ] [ text path ] ]