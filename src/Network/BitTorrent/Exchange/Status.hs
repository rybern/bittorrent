{-# LANGUAGE TemplateHaskell   #-}
module Network.BitTorrent.Exchange.Status
       ( -- * Peer status
         PeerStatus(..)
       , choking
       , interested

         -- * Session status
       , SessionStatus(..)
       , clientStatus
       , peerStatus

         -- ** Query
       , canUpload
       , canDownload

         -- * Extra
       , inverseStatus
       , defaultUnchokeSlots
       ) where

import Control.Lens
import Data.Aeson.TH
import Data.List as L
import Data.Default

-- |
data PeerStatus = PeerStatus {
    _choking    :: !Bool
  , _interested :: !Bool
  } deriving (Show, Eq)

$(makeLenses ''PeerStatus)
$(deriveJSON L.tail ''PeerStatus)

instance Default PeerStatus where
  def = PeerStatus True False

-- |
data SessionStatus = SessionStatus {
    _clientStatus :: !PeerStatus
  , _peerStatus   :: !PeerStatus
  } deriving (Show, Eq)

$(makeLenses ''SessionStatus)
$(deriveJSON L.tail ''SessionStatus)

instance Default SessionStatus where
  def = SessionStatus def def

-- | Can the /client/ transfer to the /peer/?
canUpload :: SessionStatus -> Bool
canUpload SessionStatus {..}
  = _interested _peerStatus && not (_choking _clientStatus)

-- | Can the /client/ transfer from the /peer/?
canDownload :: SessionStatus -> Bool
canDownload SessionStatus {..}
  = _interested _clientStatus && not (_choking _peerStatus)

inverseStatus :: SessionStatus -> SessionStatus
inverseStatus SessionStatus {..} = SessionStatus _peerStatus _clientStatus

-- | Indicates how many peers are allowed to download from the client
-- by default.
defaultUnchokeSlots :: Int
defaultUnchokeSlots = 4