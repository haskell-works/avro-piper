{-# LANGUAGE LambdaCase #-}
module Conduit.Splitter
where

import           Conduit
import           Control.Monad
import qualified Data.ByteString             as StrictBS
import           Data.ByteString.Builder     as BB
import           Data.ByteString.Lazy        (ByteString, fromStrict, null,
                                              toStrict)
import qualified Data.ByteString.Lazy        as BS
import           Data.ByteString.Lazy.Search (split)
import           Data.Monoid

splitDelim :: Monad m => StrictBS.ByteString -> Conduit ByteString m ByteString
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
              let (xs, mbLast) = foldr (\x (as, l) -> (maybe as (:as) l, Just x)) ([], Nothing) bs
              let lastB = maybe mempty BB.lazyByteString mbLast
              yieldB (bldr <> BB.lazyByteString x)
              forM_ xs yieldNonEmpty
              go lastB
    yieldNonEmpty bs = if (not $ BS.null bs) then yield bs else pure ()
    yieldB b = yieldNonEmpty $ BB.toLazyByteString b
