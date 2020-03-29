{-# LANGUAGE LambdaCase #-}

module Conduit.Splitter where

import Conduit
import Control.Monad
import Data.ByteString.Builder     as BB
import Data.ByteString.Lazy        (ByteString, fromStrict, null, toStrict)
import Data.ByteString.Lazy.Search (split)
import Data.Foldable
import Data.Monoid

import qualified Data.ByteString      as BS
import qualified Data.ByteString.Lazy as LBS

splitDelim :: Monad m => BS.ByteString -> ConduitT ByteString ByteString m ()
splitDelim delim = go mempty
  where
    go bldr =
      await >>= \case
        Nothing -> yieldB bldr
        Just bs ->
          case split delim bs of
            [] -> yieldB bldr >> go mempty
            [x] -> go (bldr <> BB.lazyByteString x)
            (x:bs) -> do
              let (xs, mbLast) = foldl' (\(as, l) x -> (maybe as (:as) l, Just x)) ([], Nothing) bs
              let lastB = maybe mempty BB.lazyByteString mbLast
              yieldB (bldr <> BB.lazyByteString x)
              forM_ xs yieldNonEmpty
              go lastB
    yieldNonEmpty bs = if not $ LBS.null bs then yield bs else pure ()
    yieldB b = yieldNonEmpty $ BB.toLazyByteString b
