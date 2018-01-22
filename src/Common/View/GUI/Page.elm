module Common.View.GUI.Page exposing (content, footer, grid, header, list, loading, view)

-- import Common.View.GUI.Style exposing (scaled, stylesheet)

import Common.View.GUI.Theme as Theme exposing (Theme)
import Element as Element exposing (..)
import Element.Attributes as Attributes exposing (..)


type Header variation msg
    = Header (Element Theme variation msg)


type Content variation msg
    = Content (Element Theme variation msg)


type Footer variation msg
    = Footer (Element Theme variation msg)


type alias PageItems variation msg =
    { header : Device -> Header variation msg
    , content : Device -> Content variation msg
    , footer : Device -> Footer variation msg
    }


loading : Device -> Element Theme variation msg
loading device =
    modal Theme.None [ width fill, height fill ] <|
        row Theme.Loading
            [ width fill
            , height fill
            , center
            , verticalCenter
            ]
            [ text "Loading ..."
            ]


view : Device -> PageItems variation msg -> Element Theme variation msg
view device { header, content, footer } =
    let
        (Header header_) =
            header device

        (Content content_) =
            content device

        (Footer footer_) =
            footer device
    in
    modal Theme.None [ width fill, height fill ] <|
        row Theme.None
            [ width fill
            , height fill
            , center
            , verticalCenter
            ]
            [ column Theme.Page
                [ minWidth << percent <| 50 -- TODO validate by device
                , maxWidth << percent <| 75 -- TODO validate by device
                , maxHeight << percent <| 75
                , spacing 32
                , paddingXY 64 0
                ]
                [ header_, content_, footer_ ]
            ]


header : List (Element Theme variation msg) -> (Device -> Header variation msg)
header items =
    \device -> Header (full Theme.None [] <| row Theme.Header [ center, width fill ] items)


content : List (Element Theme variation msg) -> (Device -> Content variation msg)
content items =
    \device ->
        Content
            (row Theme.Content
                [ center
                , verticalCenter
                , width fill
                , padding 16
                ]
                items
            )


list : List (Element Theme variation msg) -> (Device -> Content variation msg)
list items =
    \device ->
        -- TODO USE CUSTOM JS SCROOLBAR
        Content
            (column Theme.None
                [ paddingXY 16 16, spacingXY 0 16, scrollbars, center ]
                (List.map
                    (\item ->
                        row Theme.SelectListItem
                            [ center
                            , width fill
                            , padding 8
                            , spacingXY 32 32
                            ]
                            [ item ]
                    )
                    items
                )
            )


grid : List (Element Theme variation msg) -> (Device -> Content variation msg)
grid items =
    \device ->
        Content
            (wrappedRow Theme.None
                [ padding 16, spacing 16, scrollbars, center ]
                (List.map
                    (\item ->
                        el Theme.GridItem
                            [ center
                            , width (px 64)
                            , height (px 64)

                            -- , padding 8
                            -- , spacing 32
                            ]
                            item
                    )
                    items
                )
            )


footer : List (Element Theme variation msg) -> (Device -> Footer variation msg)
footer items =
    \device ->
        Footer
            (row Theme.Footer
                [ center
                , spacing 16
                , paddingBottom 32
                , width fill
                ]
                items
            )
