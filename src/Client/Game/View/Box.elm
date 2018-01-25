module Client.Game.View.Box exposing (style, style2)

import Style exposing (..)


style : List (Property class variation)
style =
    [ prop "background-color" "#b56f34"
    , prop "box-shadow" "inset 0 0 0 .15em #d8935a, inset 0.01em 0.01em .1em .15em #111"
    , prop "background-image" "linear-gradient(45deg, transparent 44%, rgba(20,20,20,.3) 45%, #d8935a 45%, #d8935a 55%, rgba(20,20,20,.3) 55%, transparent 56%), linear-gradient(-45deg, transparent 44%, rgba(20,20,20,.3) 45%, #d8935a 45%, #d8935a 55%, rgba(20,20,20,.3) 55%, transparent 56%)"
    , pseudo "after"
        [ prop "background-color" "#723519"
        , prop "box-shadow" "inset 0 0 0 .1em #b56f34, inset 0 0 .1em .1em #111"
        , prop "background-image" "linear-gradient(45deg, transparent 45%, #b56f34 45%, #b56f34 55%, #222 55%, transparent 56%)"
        ]
    , pseudo "before"
        [ prop "background-color" "#471e0c"
        , prop "box-shadow" "inset 0 0 0 .1em #713618, inset 0 0 .1em .1em #111"
        , prop "background-image" "linear-gradient(-45deg, transparent 45%, #713618 45%, #713618 55%, transparent 55%)"
        ]
    ]


style2 : List (Property class variation)
style2 =
    [ prop "background-color" "#dbdbdb"
    , prop "box-shadow" "inset 0 0 0 .08em hsla(1,0%,0%,.1)"
    , pseudo "after"
        [ prop "background-color" "#AAAAAA"
        , prop "box-shadow" "inset 0 0 0 .08em hsla(1,0%,0%,.1)"
        ]
    , pseudo "before"
        [ prop "background-color" "#888888"
        , prop "box-shadow" "inset 0 0 0 .08em hsla(1,0%,0%,.1)"
        ]
    ]
