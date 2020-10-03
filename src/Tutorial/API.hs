{-# LANGUAGE TypeOperators #-}

module Tutorial.API where

import Data.Text (Text)
import Servant (Get, JSON, (:>))

type API = "boop" :> Get '[JSON] Text
