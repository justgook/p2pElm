module Builder.Update exposing (..)

import Builder.Model exposing(Model)
import Builder.Message exposing (Msg(Increment, Decrement, TimeUpdate, KeyDown))
 
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
 case msg of
    Increment ->
      (model, Cmd.none)
      
    Decrement ->
      (model, Cmd.none)
    
    TimeUpdate dt ->
      (model, Cmd.none)
    
    KeyDown key ->
      let 
        _ = Debug.log "Key pressed" key
      in
        (model, Cmd.none)  
