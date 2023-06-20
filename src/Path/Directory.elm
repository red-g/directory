module Path.Directory exposing (Directory, decoder, encode, root)

{-| An absolute directory path. Give this to your backend to load new directories into Elm!

@docs Directory, decoder, encode, root

-}

import Internal
import Json.Decode exposing (Decoder)
import Json.Encode as Encode


{-| An absolute directory path. Give this to your backend to load new directories into Elm!
-}
type alias Directory =
    Internal.DirectoryPath


{-| Encode a `Directory` path to the following JSON schema:

        {
            "segments": string[]
        }

-}
encode : Directory -> Encode.Value
encode =
    Internal.pathEncode


{-| Decode a `Directory` path from the following JSON schema:

        {
            "segments": string[]
        }

-}
decoder : Decoder Directory
decoder =
    Internal.pathDecoder


{-| The root directory. You'll probably load your first data from here.
-}
root : Directory
root =
    Internal.pathRoot
