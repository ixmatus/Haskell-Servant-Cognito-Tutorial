{-# LANGUAGE TypeOperators #-}

module Tutorial.API where

import Servant ((:>), Get, JSON)
import Data.Text (Text)

type API = "boop" :> Get '[JSON] Text
