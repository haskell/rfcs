module PreludeIO (
    FilePath, IOError, ioError, userError, catch,
    putChar, putStr, putStrLn, print,
    getChar, getLine, getContents, interact,
    readFile, writeFile, appendFile, readIO, readLn
  ) where

import PreludeBuiltin


type  FilePath = String

data IOError    -- The internals of this type are system dependent

instance  Show IOError  where ...
instance  Eq IOError  where ...

ioError    ::  IOError -> IO a 
ioError    =   primIOError
	   
userError  ::  String -> IOError
userError  =   primUserError
	   
catch      ::  IO a -> (IOError -> IO a) -> IO a 
catch      =   primCatch
	   
putChar    :: Char -> IO ()
putChar    =  primPutChar
	   
putStr     :: String -> IO ()
putStr s   =  mapM_ putChar s
	   
putStrLn   :: String -> IO ()
putStrLn s =  do putStr s
                 putStr "\n"
	   
print      :: Show a => a -> IO ()
print x    =  putStrLn (show x)
	   
getChar    :: IO Char
getChar    =  primGetChar
	   
getLine    :: IO String
getLine    =  do c <- getChar
                 if c == '\n' then return "" else 
                    do s <- getLine
                       return (c:s)
            
getContents :: IO String
getContents =  primGetContents

interact    ::  (String -> String) -> IO ()
-- The hSetBuffering ensures the expected interactive behaviour
interact f  =  do hSetBuffering stdin  NoBuffering
                  hSetBuffering stdout NoBuffering
                  s <- getContents
                  putStr (f s)

readFile   :: FilePath -> IO String
readFile   =  primReadFile
	   
writeFile  :: FilePath -> String -> IO ()
writeFile  =  primWriteFile
	   
appendFile :: FilePath -> String -> IO ()
appendFile =  primAppendFile

  -- raises an exception instead of an error
readIO   :: Read a => String -> IO a
readIO s =  case [x | (x,t) <- reads s, ("","") <- lex t] of
              [x] -> return x
              []  -> ioError (userError "Prelude.readIO: no parse")
              _   -> ioError (userError "Prelude.readIO: ambiguous parse")

readLn :: Read a => IO a
readLn =  do l <- getLine
             r <- readIO l
             return r
