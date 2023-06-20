module Directory.Item exposing (Item(..), decoder)

{-| An `Item` within a `Directory` directory; either a `File` or a `SubDirectory`.
They are located relative to their parent directory.

@docs Item, decoder

-}

import Directory.File as File exposing (File)
import Directory.SubDirectory as SubDirectory exposing (SubDirectory)
import Json.Decode as Decode exposing (Decoder)


{-| An `Item` within a `Directory` directory; either a `File` or a `SubDirectory`.
`Item`s are located relative to their parent directory.
-}
type Item
    = File File
    | SubDirectory SubDirectory


{-| Decode a directory `Item` from the following JSON schema:

        {
            "SubDirectory"?: <Directory.SubDirectory>,
            "File"?: <Directory.File>
        }

-}
decoder : Decoder Item
decoder =
    Decode.oneOf
        [ Decode.field "SubDirectory" <| Decode.map SubDirectory SubDirectory.decoder
        , Decode.field "File" <| Decode.map File File.decoder
        ]
