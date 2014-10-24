{-# LANGUAGE OverloadedStrings #-}

module System.Doctem.TemplateSpec where

import qualified Data.Text.Lazy as T

import Data.Map
import System.Doctem.Template
import System.Doctem.Types
import Test.Hspec
import Text.Hastache

spec :: Spec
spec = do
  describe "createContext" $ do
    it "includes tag version as a property" $ do
      let context = createContext "7.6" $ fromList []
      (show `fmap` context "tag") `shouldReturn` "MuVariable \"7.6\""

  describe "renderDockerfile" $ do
    it "replaces all template placeholders with the given values" $ do
      let context = createContext "7.6" $ fromList [("ghc", "7.6.3")]
      let expectedDockerfile = T.unlines [ "FROM ubuntu:14.04"
                                         , ""
                                         , "ENV DEBIAN_FRONTEND noninteractive"
                                         , ""
                                         , "RUN apt-get update && apt-get install -y software-properties-common"
                                         , "RUN add-apt-repository ppa:hvr/ghc"
                                         , "RUN apt-get update && apt-get install -y ghc-7.6.3"
                                         , ""
                                         , "ENTRYPOINT [\"ghci\"]"
                                         ]
      renderDockerfile context `shouldReturn` expectedDockerfile
