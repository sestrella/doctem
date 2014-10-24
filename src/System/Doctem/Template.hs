{-# LANGUAGE OverloadedStrings #-}

module System.Doctem.Template where

import qualified Data.Map as M
import qualified Data.Text as T
import qualified Data.Text.Lazy as TL
import qualified Data.Text.Lazy.IO as TLIO

import Data.Yaml
import System.Directory
import System.Doctem.Types
import Text.Hastache

readProperties :: IO (Either ParseException Properties)
readProperties = decodeFileEither "doctem.yml"

writeDockerfiles :: Properties -> IO ()
writeDockerfiles props = do
  dockerfiles <- renderDockerfiles props
  mapM_ writeDockerfile $ zip (M.keys props) dockerfiles

renderDockerfiles :: Properties -> IO [Dockerfile]
renderDockerfiles = mapM renderDockerfile . createContexts

createContexts :: Properties -> [MuContext IO]
createContexts = M.elems . M.mapWithKey createContext

createContext :: Tag -> Attributes -> MuContext IO
createContext tag attrs key = do
  let a = M.insert "tag" tag attrs
  return $ maybe MuNothing MuVariable $ M.lookup key a

renderDockerfile :: MuContext IO -> IO Dockerfile
renderDockerfile = hastacheFile defaultConfig "Dockertemplate"

writeDockerfile :: (Tag, Dockerfile) -> IO ()
writeDockerfile (tag, dockerfile) = do
  createDirectoryIfMissing False path
  TLIO.writeFile (path ++ "/Dockerfile") dockerfile
  where
    path = T.unpack tag
