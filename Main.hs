module Main where

import Control.Exception.Base
import System.Doctem.Template

main :: IO ()
main = do
  eitherProperties <- readProperties
  case eitherProperties of
    Left ex    -> throw ex
    Right tags -> writeDockerfiles tags
