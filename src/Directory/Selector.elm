module Directory.Selector exposing (Selector, back, forward, list, path, reselect, selected, withItem)

{-| Like a `Directory`, but must contain at least one item.
You can select an `Item` in the directory, and convert it to an absolute `Path`.

@docs Selector, back, forward, list, path, reselect, selected, withItem

-}

import Directory exposing (Directory)
import Directory.Item exposing (Item(..))
import Internal
import Path exposing (Path)
import Path.Directory as Path
import SelectList exposing (SelectList)


{-| A `Directory` with a selected `Item`.
You can convert the selected `Item` to an absolute `Path`.
-}
type Selector
    = Selector Path.Directory (SelectList Item)


{-| Get a `SelectList` of `Item`s in `Selector`.
-}
list : Selector -> SelectList Item
list (Selector _ l) =
    l


{-| Get the selected `Item` in `selector`.
-}
selected : Selector -> Item
selected selector =
    SelectList.selected <| list selector


{-| Get the path to `selector`s directory.
-}
path : Selector -> Path.Directory
path (Selector p _) =
    p


{-| Get the `Path` to `selector`s focused `Item`. You could get a `File` or a `SubDirectory`!
-}
forward : Selector -> Path
forward selector =
    case selected selector of
        File file ->
            Path.File <| Internal.filePath (path selector) file

        SubDirectory subDirectory ->
            Path.Directory <| Internal.pathForward subDirectory <| path selector


{-| Create a `Selector` from `directory`, with focus on the `Item` at `index`.
-}
withItem : Int -> Directory -> Maybe Selector
withItem index directory =
    case Directory.items directory of
        [] ->
            Nothing

        member :: rest ->
            selectListWithIndex index [] member rest
                |> Maybe.map (Selector <| Directory.path directory)


selectListWithIndex : Int -> List a -> a -> List a -> Maybe (SelectList a)
selectListWithIndex index befores item afters =
    if index == 0 then
        Just <| SelectList.fromLists befores item afters

    else
        case afters of
            [] ->
                Nothing

            after :: rest ->
                selectListWithIndex (index - 1) (item :: befores) after rest


{-| Move `selector`'s focus to the `Item` at `index`.
-}
reselect : Int -> Selector -> Selector
reselect index selector =
    list selector
        |> SelectList.attempt (SelectList.selectBy index)
        |> Selector (path selector)


{-| Get the path to `selector`'s parent directory.
-}
back : Selector -> Path.Directory
back selector =
    Internal.pathBack <| path selector
