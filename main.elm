module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (style)
import AnimationFrame exposing (diffs)

main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

type alias Model =
    { 
        frame: Int
    }

init : ( Model, Cmd Msg )
init =
    ( Model 0 , Cmd.none )

type Msg
    = NoOp | Frame

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            (model, Cmd.none)
        Frame ->
            ({model | frame=model.frame+1}, Cmd.none)



subscriptions : Model -> Sub Msg
subscriptions model =
    diffs <| always Frame

barCount: Int
barCount =
    40

barWidth: Float
barWidth =
    100 / toFloat barCount

bars: List Int
bars =
    List.range 0 <| barCount-1

barDiv : Int -> Int -> Html msg
barDiv frame index =
    let
        frameFloat = toFloat frame
        indexFloat = toFloat index
        translateY = (sin (frameFloat/10 + indexFloat/5)) * 100 * 0.5
        hue =  (360 // barCount * index - frame) % 360
        color = "hsl(" ++ toString hue ++ ", 95%, 55%)"
        width = toString barWidth ++ "%"
        barX = toString (barWidth * indexFloat) ++ "%"
        rotation = (frame+index) % 360
        transform = "scale(0.8,.5) translateY(" ++ toString translateY ++ "%) rotate(" ++ toString rotation ++ "deg)"
    in        
        div [ style [("border-radius","50%"),("backgroundColor",color), ("width",width),("left", barX),("height","100%"),("position","absolute"),("transform",transform)]] []


view : Model -> Html Msg
view model =
    let 
        divs = List.map (barDiv model.frame) bars
    in
    div [ style [("width","100%"), ("height","150px"),("position","relative")]]
        <|  divs
        
