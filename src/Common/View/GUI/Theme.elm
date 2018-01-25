module Common.View.GUI.Theme exposing (ButtonStyles(..), Theme(..), Variation(..))


type Theme
    = None
    | Page
    | Loading
    | Header
    | Content
    | Footer
    | Button ButtonStyles
    | SelectListItem
    | GridItem


type ButtonStyles
    = Active
    | Disabled


type Variation
    = Default
