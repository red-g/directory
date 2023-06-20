module Path exposing (Path(..), decoder, encode)

{-| An absolute path to either a file or a directory. Give these to your backend to load them into Elm!

@docs Path, decoder, encode

-}

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Path.Directory as Directory exposing (Directory)
import Path.File as File exposing (File)


{-| An absolute path to either a file or a directory. Give these to your backend to load them into Elm!
-}
type Path
    = File File
    | Directory Directory


{-| Decode a `Path` from the following JSON schema:

        {
            "File"?: <Path.File>,
            "Directory"?: <Path.Directory>
        }

-}
decoder : Decoder Path
decoder =
    Decode.oneOf
        [ Decode.field "File" <| Decode.map File File.decoder
        , Decode.field "Directory" <| Decode.map Directory Directory.decoder
        ]


{-| Encode a `Path` to the following JSON schema:

        {
            "File"?: <Path.File>,
            "Directory"?: <Path.Directory>
        }

-}
encode : Path -> Encode.Value
encode path =
    case path of
        File file ->
            Encode.object
                [ ( "File", File.encode file )
                ]

        Directory directory ->
            Encode.object
                [ ( "Directory", Directory.encode directory )
                ]
