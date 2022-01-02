{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE CPP #-}

{-|
Module      : Error.Diagnose.Diagnostic
Description : Defines location information as a simple record.
Copyright   : (c) Mesabloo, 2021
License     : BSD3
Stability   : experimental
Portability : Portable
-}
module Error.Diagnose.Position (Position(..)) where

#ifdef USE_AESON
import Data.Aeson (ToJSON(..), object, (.=))
#endif
import Data.Default (Default, def)
import Data.Hashable (Hashable)
import Data.Text (Text)

import GHC.Generics (Generic(..))

import Prettyprinter (Pretty(..), colon)
-- import Text.PrettyPrint.ANSI.Leijen (Pretty(..), text, colon, int)


-- | Contains information about the location about something.
--
--   It is best used in a datatype like:
--
--   > data Located a
--   >   = a :@ Position
--   >   deriving (Show, Eq, Ord, Functor, Traversable)
data Position
  = Position
  {
      -- | The beginning line and column of the span.
      begin :: (Int, Int)
  ,
      -- | The end line and column of the span.
      end   :: (Int, Int)
  ,
      -- | The file this position spans in.
      file  :: FilePath
  }
  deriving (Show, Eq, Generic)

instance Ord Position where
  Position b1 e1 _ `compare` Position b2 e2 _ = (b1, e1) `compare` (b2, e2)

instance Pretty Position where
  pretty (Position (bl, bc) (el, ec) f) = pretty f <> at <> pretty bl <> colon <> pretty bc <> dash <> pretty el <> colon <> pretty ec
    where at = pretty @Text "@"
          dash = pretty @Text "-"

instance Hashable Position where

instance Default Position where
  def = Position (1, 1) (1, 1) "<no-file>"

#ifdef USE_AESON
instance ToJSON Position where
  toJSON (Position (bl, bc) (el, ec) file) =
    object [ "beginning" .= object [ "line" .= bl, "column" .= bc ]
           , "end" .= object [ "line" .= el, "column" .= ec ]
           , "file" .= file
           ]
#endif