module Path.File exposing (File, decoder, directory, encode, extension, stem)

{-| An absolute file path.

@docs File, decoder, directory, encode, extension, stem

-}

import Internal
import Json.Decode exposing (Decoder)
import Json.Encode as Encode
import Path.Directory exposing (Directory)


{-| An absolute file path.
-}
type alias File =
    Internal.FilePath


{-| Get the part of a file name before its type.
-}
stem : File -> String
stem =
    Internal.filePathStem


{-| Get the type of a file, if it has one.
-}
extension : File -> Maybe String
extension =
    Internal.filePathExtension


{-| Get the directory that contains the file.
-}
directory : File -> Directory
directory =
    Internal.fileDirectory


{-| Decode a `File` path from the following JSON schema:

        {
            "stem": string,
            "extension": string?,
            "directory": <Directory>
        }

-}
decoder : Decoder File
decoder =
    Internal.filePathDecoder


{-| Encode a `File` path to the following JSON schema:

        {
            "stem": string,
            "extension": string?,
            "directory": <Directory>
        }

-}
encode : File -> Encode.Value
encode =
    Internal.filePathEncode
