module Server.Update.NoLevel exposing (Msg(..), update)

import Common.World.Main exposing (World, decode)


(!!) : Int -> List a -> Maybe a
(!!) index list =
    if List.length list >= index then
        List.take index list
            |> List.reverse
            |> List.head
    else
        Nothing


type Msg
    = Level Int


update : Msg -> List String -> Maybe World
update (Level index) rooms =
    case index !! rooms of
        Just room ->
            Just (decode room)

        Nothing ->
            Nothing
