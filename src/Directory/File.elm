module Directory.File exposing (File, decoder, extension, stem)

{-| A `File` located relative to its parent directory.

@docs File, decoder, extension, stem

-}

import Internal
import Json.Decode exposing (Decoder)


{-| A `File` located relative to its parent directory.
-}
type alias File =
    Internal.File


{-| Decode a `File` from the following JSON schema:

        {
            "stem": string,
            "extension": string?
        }

-}
decoder : Decoder File
decoder =
    Internal.fileDecoder


{-| Get the part of the file name before its type.
-}
stem : File -> String
stem =
    Internal.fileStem


{-| Get the file type of a file, if it has one.
-}
extension : File -> Maybe String
extension =
    Internal.fileExtension
