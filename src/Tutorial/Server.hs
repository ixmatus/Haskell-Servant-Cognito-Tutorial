{-# LANGUAGE ExplicitNamespaces #-}
{-# LANGUAGE TypeOperators #-}

module Tutorial.Server where

import Relude

import Data.String (IsString (fromString))
import GHC.Generics (Generic)
import qualified Network.Wai as Wai
import qualified Network.Wai.Handler.Warp as Warp
import qualified Options.Applicative as Options
import Options.Generic (
  ParseField,
  ParseFields,
  ParseRecord (),
  Unwrapped,
  Wrapped,
  getOnly,
  parseRecord,
  type (:::),
  type (<!>) (..),
  type (<?>) (..),
 )
import qualified Options.Generic
import qualified Servant
import Tutorial.API (API)

-- | CLI options for the web server application.
data Options w = Options
  { bindPort ::
      w ::: Warp.Port
        <!> "8080"
        <?> "Specify the binding port"
  , bindHost ::
      w ::: Warp.HostPreference
        <!> "127.0.0.1"
        <?> "Specify the binding interface"
  }
  deriving (Generic)

instance ParseRecord (Options Wrapped)
deriving instance Show (Options Wrapped)

instance ParseField Warp.HostPreference where
  parseField h l s d = fromString <$> parseHost
    where
      parseHost :: Options.Parser String
      parseHost =
        Options.strOption $
          Options.metavar "HOST"
            <> foldMap (Options.help . toString) h
            <> foldMap (Options.long . toString) l
            <> foldMap Options.short s
            <> foldMap Options.value d

instance ParseFields Warp.HostPreference

instance ParseRecord Warp.HostPreference where
  parseRecord = fmap getOnly parseRecord

-- | Main entrypoint into the webserver application. Since this is
-- exposed by the library it is intended to be imported and called by
-- another main module for an executable.
main :: IO ()
main = Options.Generic.unwrapRecord programDescription >>= runWebServer
  where
    programDescription :: Text
    programDescription = "Servant + Cognito example web application"

-- | Given an 'Options' record, customize the Warp 'Settings' and
-- run the application.
runWebServer :: Options Unwrapped -> IO ()
runWebServer Options{bindPort, bindHost} = Warp.runSettings settings app
  where
    settings =
      Warp.setPort bindPort
        . Warp.setHost bindHost
        $ Warp.defaultSettings

-- | Servant API type.
api :: Proxy API
api = Proxy

-- | Servant application composed of an API type and an
-- implementation of that type.
app :: Wai.Application
app = Servant.serve api server

server :: Servant.Server API
server = return "BOOP"
