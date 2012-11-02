module Main (main) where

import            Control.Monad
import            Data.Char
import            Data.List
import            System.Directory
import            System.Environment
import            System.Process

-- | Take the arguments passed from the commandline and the filename of the
-- Shakefile, then execute it, passing the arguments.
runShakefile :: [String] -> String -> IO ()
runShakefile args fn = void . system $ unwords ["runghc", fn, unwords args]

-- | Determine if the filename specified is a Shakefile. Any file who's
-- name starts with Shakefile is marked as a Shakefile. Filenames are
-- case-insensitive.
isShakefile :: String -> Bool
isShakefile fn = "shakefile" `isPrefixOf` map toLower fn

-- | Get the commandline arguments, if any, look for a Shakefile, and try
-- to execute it. Error out if no shakefile is found.
main :: IO ()
main = do
  args   <- getArgs
  files  <- getDirectoryContents =<< getCurrentDirectory
  maybe (error "No shakefile found") (runShakefile args) $ find isShakefile files

