module Directory.SubDirectory exposing (SubDirectory, decoder, name)

{-| A `Directory` located relative to its parent directory.

@docs SubDirectory, decoder, name

-}

import Internal
import Json.Decode exposing (Decoder)


{-| A `Directory` located relative to its parent directory. Unlike a `Directory`, a `SubDirectory` has no knowledge of its contents.
-}
type alias SubDirectory =
    Internal.SubDirectory


{-| Decode a `SubDirectory` from the following JSON structure:

        {
            "name": string
        }

-}
decoder : Decoder SubDirectory
decoder =
    Internal.subDirectoryDecoder


{-| Get the name of a `SubDirectory`.
-}
name : SubDirectory -> String
name =
    Internal.subDirectoryName
