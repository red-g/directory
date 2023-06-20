module Internal exposing (..)

{-| The `Internal` module for the file system. We use an `Internal` module to bundle interrelated types and functions that we don't want to expose to the user.
You should never use this module directly! Other file system modules re-export this stuff in bite-sized chunks.

In our file system, you can work with paths in 3 ways:

  - you can get a root `PathDirectory` from `pathRoot`
  - you can go `back` a `DirectoryPath` level from a `Directory` or `Selector`
  - you can go `forward` to a `Selector`'s current directory `Member`, getting either a `DirectoryPath` or a `FilePath`

Once you have a `DirectoryPath`, you can get a `Directory` with your own `load` effect!
Note that we do not allow direct modification of paths——you can only go `back` or `forward` before loading a new `Directory`.
We limit access to only what is necessary for a file explorer; this completely prevents the use of invalid paths.

-}

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode


type File
    = File_ { stem : String, extension : Maybe String }


type SubDirectory
    = SubDirectory_ { name : String }


type DirectoryPath
    = DirectoryPath_ { segments : List String }


type FilePath
    = FilePath_ { directory : DirectoryPath, stem : String, extension : Maybe String }


fileDirectory : FilePath -> DirectoryPath
fileDirectory (FilePath_ { directory }) =
    directory


filePathExtension : FilePath -> Maybe String
filePathExtension (FilePath_ { extension }) =
    extension


filePathStem : FilePath -> String
filePathStem (FilePath_ { stem }) =
    stem


subDirectoryName : SubDirectory -> String
subDirectoryName (SubDirectory_ { name }) =
    name


subDirectoryDecoder : Decoder SubDirectory
subDirectoryDecoder =
    Decode.map (\name -> SubDirectory_ { name = name }) <|
        Decode.field "name" Decode.string


fileDecoder : Decoder File
fileDecoder =
    Decode.map2 (\stem extension -> File_ { stem = stem, extension = extension })
        (Decode.field "stem" Decode.string)
        (Decode.field "extension" <| Decode.nullable Decode.string)


fileStem : File -> String
fileStem (File_ { stem }) =
    stem


filePath : DirectoryPath -> File -> FilePath
filePath directory file =
    FilePath_ { directory = directory, stem = fileStem file, extension = fileExtension file }


fileExtension : File -> Maybe String
fileExtension (File_ { extension }) =
    extension


pathSegments : DirectoryPath -> List String
pathSegments (DirectoryPath_ { segments }) =
    segments


pathMap : (List String -> List String) -> DirectoryPath -> DirectoryPath
pathMap f path =
    DirectoryPath_ <| { segments = f <| pathSegments path }


pathFromSegments : List String -> DirectoryPath
pathFromSegments segments =
    DirectoryPath_ { segments = segments }


pathForward : SubDirectory -> DirectoryPath -> DirectoryPath
pathForward directory path =
    pathMap ((::) (subDirectoryName directory)) path


pathBack : DirectoryPath -> DirectoryPath
pathBack path =
    pathMap (List.drop 1) path


pathRoot : DirectoryPath
pathRoot =
    pathFromSegments []


pathEncode : DirectoryPath -> Encode.Value
pathEncode path =
    Encode.list Encode.string <| List.reverse <| pathSegments path


pathDecoder : Decoder DirectoryPath
pathDecoder =
    Decode.field "segments" <|
        Decode.map (List.reverse >> pathFromSegments) <|
            Decode.list Decode.string


filePathDecoder : Decoder FilePath
filePathDecoder =
    Decode.map3
        (\directory stem extension -> FilePath_ { directory = directory, stem = stem, extension = extension })
        (Decode.field "directory" pathDecoder)
        (Decode.field "stem" Decode.string)
        (Decode.field "extension" <| Decode.nullable Decode.string)


filePathEncode : FilePath -> Encode.Value
filePathEncode (FilePath_ { directory, stem, extension }) =
    Encode.object
        [ ( "directory", pathEncode directory )
        , ( "stem", Encode.string stem )
        , ( "extension", maybeEncode Encode.string extension )
        ]


maybeEncode : (a -> Encode.Value) -> Maybe a -> Encode.Value
maybeEncode encode maybe =
    case maybe of
        Just value ->
            encode value

        Nothing ->
            Encode.null
