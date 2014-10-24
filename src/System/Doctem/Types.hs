module System.Doctem.Types where

import qualified Data.Text.Lazy as T

import Data.Map
import Data.Text

type Properties = Map Tag Attributes
type Tag        = Text
type Attributes = Map Text Text
type Dockerfile = T.Text
