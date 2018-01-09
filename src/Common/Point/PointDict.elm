module Common.Point.PointDict
    exposing
        ( PointDict
        , empty
        , fromList
        , insert
        , keys
        , union
        )

import AllDict exposing (AllDict)
import Common.Point as Point exposing (Point(Point))


type alias PointDict v =
    AllDict Point v ( Int, Int )


compare : Point -> ( Int, Int )
compare (Point x y) =
    ( x, y )


empty : PointDict v
empty =
    AllDict.empty compare


union : PointDict v -> PointDict v -> PointDict v
union t1 t2 =
    AllDict.union t1 t2


fromList : List ( Point, v ) -> PointDict v
fromList xs =
    AllDict.fromList compare xs


insert : Point -> v -> PointDict v -> PointDict v
insert key value dict =
    AllDict.update key (always (Just value)) dict


keys : PointDict v -> List Point
keys dict =
    AllDict.keys dict
