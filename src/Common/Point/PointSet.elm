module Common.Point.PointSet
    exposing
        ( PointSet
        , empty
        , fromList
        , insert
        , toList
        , union
        )

import Common.Point as Point exposing (Point(Point))
import Common.Point.PointDict as PointDict exposing (PointDict)


{- based on [EverySet](https://github.com/Gizra/elm-all-set/blob/1.0.0/src/EverySet.elm) -}


{-| Represents a set of unique values.
-}
type PointSet
    = PointSet (PointDict ())


{-| Create an empty set.
-}
empty : PointSet
empty =
    PointSet PointDict.empty


{-| Get the union of two sets. Keep all values.
-}
union : PointSet -> PointSet -> PointSet
union (PointSet d1) (PointSet d2) =
    PointSet <| PointDict.union d1 d2


{-| Convert a list into a set, removing any duplicates.
-}
fromList : List Point -> PointSet
fromList xs =
    List.foldl insert empty xs


{-| Insert a value into a set.
-}
insert : Point -> PointSet -> PointSet
insert k (PointSet d) =
    PointSet <| PointDict.insert k () d


{-| Convert a set into a list, sorted from lowest to highest.
-}
toList : PointSet -> List Point
toList (PointSet d) =
    PointDict.keys d
