module Main where

import           Conduit                     as C
import           Control.Arrow               (left)
import           Control.Monad
import           Control.Monad.Except
import qualified Data.Avro                   as A
import qualified Data.Avro.Decode            as A
import qualified Data.Avro.Schema            as A
import qualified Data.Avro.Types             as A
import qualified Data.ByteString             as StrictBS
import qualified Data.ByteString.Char8       as StrictC8

import           Data.ByteString.Builder     as BB
import           Data.ByteString.Lazy        (ByteString, fromStrict, null,
                                              toStrict)
import qualified Data.ByteString.Lazy        as BS
import           Data.ByteString.Lazy.Search (split)
import           Data.Monoid
import           Kafka.Avro

import           Conduit.Splitter
import           Data.Aeson                  as J

import           Error
import           Options


main :: IO ()
main = do
  opt <- parseOptions
  sr <- schemaRegistry (optSchemaRegistry opt)
  runConduit $
    C.stdinC
    .| mapC fromStrict
    .| splitDelim (StrictC8.pack $ optDelimiter opt)
    .| mapMC (\x -> do
                        res <- decodeMessage sr x
                        case res of
                          Left err -> liftIO (print x) >> return res
                          _        -> return res
             )

    .| mapC failBadly
    .| mapC J.encode

    .| unlinesAsciiC
    .| mapC toStrict
    .| stdoutC


decodeMessage :: MonadIO m => SchemaRegistry -> ByteString -> m (Either DecodeError (A.Value A.Type))
decodeMessage sr bs = runExceptT $ do
  (sid, payload) <- asExceptTPure id . maybeToEither BadPayloadNoSchemaId $ extractSchemaId bs
  sch            <- asExceptT DecodeRegistryError (loadSchema sr sid)
  asExceptT (DecodeError sch) (pure $ A.decodeAvro sch payload)


