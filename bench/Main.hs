{-# OPTIONS -fno-warn-orphans #-}
module Main (main) where

import Control.DeepSeq
import Criterion.Main
import Network

import Network.BitTorrent.Exchange.Protocol as BT
import Data.Torrent.Block as BT
import Data.Torrent.Bitfield as BT


instance NFData PortNumber where
  rnf = rnf . (fromIntegral :: PortNumber -> Int)

instance NFData BlockIx where
  rnf (BlockIx a b c) = a `deepseq` b `deepseq` rnf c

instance NFData Block where
  rnf (Block a b c) = a `deepseq` b `deepseq` rnf c

instance NFData Bitfield

instance NFData Message where
  rnf (Have i)     = rnf i
  rnf (Bitfield b) = rnf b
  rnf (Request  b) = rnf b
  rnf (Piece    b) = rnf b
  rnf (Cancel   b) = rnf b
  rnf (Port     i) = rnf i
  rnf _ = ()  -- other fields are forced by pattern matching

{-
encodeMessages :: [Message] -> ByteString
encodeMessages xs = runPut (mapM_ put xs)

decodeMessages :: ByteString -> Either String [Message]
decodeMessages = runGet (many get)
-}

main :: IO ()
main = defaultMain []
