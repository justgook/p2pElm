module Common.Background exposing (view)

import Html exposing (Html, div)
import Html.Attributes exposing (class)


view : Html msg
view =
    div []
        [ div [ class "cloud large cloud-1" ] [ div [] [], div [] [], div [] [], div [] [] ]
        , div [ class "cloud normal cloud-2" ] [ div [] [], div [] [], div [] [], div [] [] ]
        , div [ class "cloud small cloud-3" ] [ div [] [], div [] [], div [] [], div [] [] ]
        , div [ class "cloud tiny cloud-4" ] [ div [] [], div [] [], div [] [], div [] [] ]
        , div [ class "cloud large cloud-5" ] [ div [] [], div [] [], div [] [], div [] [] ]
        , div [ class "cloud normal cloud-6" ] [ div [] [], div [] [], div [] [], div [] [] ]
        , div [ class "cloud small cloud-7" ] [ div [] [], div [] [], div [] [], div [] [] ]
        , div [ class "cloud tiny cloud-8" ] [ div [] [], div [] [], div [] [], div [] [] ]
        , div [ class "cloud small cloud-9" ] [ div [] [], div [] [], div [] [], div [] [] ]
        , div [ class "cloud normal cloud-10" ] [ div [] [], div [] [], div [] [], div [] [] ]
        , div [ class "cloud tiny cloud-11" ] [ div [] [], div [] [], div [] [], div [] [] ]
        , div [ class "cloud small cloud-12" ] [ div [] [], div [] [], div [] [], div [] [] ]
        ]
