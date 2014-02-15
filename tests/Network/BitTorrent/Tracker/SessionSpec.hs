module Network.BitTorrent.Tracker.SessionSpec (spec) where
import Data.Default
import Data.List as L
import Network.URI
import Test.Hspec

import Data.Torrent
import Network.BitTorrent.Tracker.List
import Network.BitTorrent.Tracker.RPC.UDPSpec (trackerURIs)
import Network.BitTorrent.Tracker.RPC
import Network.BitTorrent.Tracker.Session


trackers :: TrackerList URI
trackers = trackerList def { tAnnounceList = Just [trackerURIs] }

spec :: Spec
spec = do
  describe "Session" $ do
    it "" $ do
      withManager def def $ \ m -> do
        s <- newSession def trackers
        notify m s Started
        peers <- askPeers m s
        peers `shouldSatisfy` (not . L.null)