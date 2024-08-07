{-# LANGUAGE MultiParamTypeClasses #-}

module Error.Diagnose.Compat.Hints where

import Error.Diagnose (Note, Position, Report)
    
-- | A class mapping custom errors of type @e@ with messages of type @msg@.
class HasHints e msg where
  -- | Defines all the hints associated with a given custom error.
  hints :: e -> [Note msg]
  mkReports :: [Report msg] -> Position -> e -> [Report msg]

  hints = const mempty
  mkReports defRep _pos _e = defRep


-- this is a sane default for 'Void'
-- but this can be redefined
--
-- instance HasHints Void msg where
--   hints _ = mempty
--   mkReport defRep _ _ = defRep
