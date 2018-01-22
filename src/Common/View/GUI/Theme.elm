module Common.View.GUI.Theme exposing (ButtonStyles(..), Theme(..))


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
