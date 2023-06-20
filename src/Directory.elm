module Directory exposing (Directory, back, decoder, items, path)

{-| An absolutely located directory containing a list of items.

@docs Directory, back, decoder, items, path

-}

import Directory.Item exposing (Item)
import Internal
import Json.Decode as Decode exposing (Decoder)
import Path.Directory as Path


{-| An absolutely located directory containing a list of items.
-}
type Directory
    = Directory Path.Directory (List Item)


{-| Get a `List` of `Item`s in a `Directory`.
-}
items : Directory -> List Item
items (Directory _ is) =
    is


{-| Get the path to a `Directory`.
-}
path : Directory -> Path.Directory
path (Directory p _) =
    p


{-| Decode a `Directory` from the following JSON schema:

    {
        "path": <Path.Directory>,
        "members": <List Directory.Item>
    }

-}
decoder : Decoder Directory
decoder =
    Decode.map2 Directory
        (Decode.field "path" Path.decoder)
        (Decode.field "members" <| Decode.list Directory.Item.decoder)


{-| Get the parent directory of a `Directory`
-}
back : Directory -> Path.Directory
back directory =
    Internal.pathBack <| path directory
