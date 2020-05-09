{-# LANGUAGE OverloadedStrings #-}
module SplitterSpec
where

import           Conduit
import           Conduit.Splitter
import           Data.ByteString      (ByteString)
import qualified Data.ByteString.Lazy as LBS
import           Data.Conduit.List
import           Data.Monoid
import           Test.Hspec

{- HLINT ignore "Redundant do"        -}

spec :: Spec
spec = describe "SplitterSpec" $ do
  let delim = "\n---\n"
  it "should split" $ do
    let res = runConduitPure $ sourceList ["abra", "cadabra" <> delim, "more" <> delim, "good", "ness"]
              .| splitDelim (LBS.toStrict delim)
              .| sinkList
    res `shouldBe` ["abracadabra", "more", "goodness"]
