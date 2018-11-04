
-- This generates the prelude index to the report by hyper-linking all
-- of the names in a hand-written document.  This is probably too
-- obscure to bother explaining.  Hardwires for the Haskell report at the
-- moment.

module Main where

import Data.Char
import Data.List
import System.IO.Error

main :: IO ()
main = do refs <- readRefFile "reportrefs"
          doFiles refs ["prelude-index"]

doFiles :: Refs -> [FilePath] -> IO ()
doFiles r files = do mapM_ (doFile r) files
                     putStrLn "Done."

doFile :: Refs -> FilePath -> IO ()
doFile r f = catchIOError
               (do putStrLn ("Reading " ++ f ++ ".idx")
                   ls <- readFile (f ++ ".idx")
                   let output = expandAllRefs r (lines ls)
                   writeFile ("haskell-report-html/" ++ f ++ ".html")
                             (unlines output))
               (\err -> putStrLn ("Error: " ++ show err))

-- This sets up the parts of the state that need to be reset at the start of
-- each file.

type Refs = [(String,String)]

expandAllRefs :: Refs -> [String] -> [String]
expandAllRefs r ls = expandAll1 r False ls

expandAll1 :: Refs -> Bool -> [String] -> [String]
expandAll1 _ _     [] = []
expandAll1 r table (l:ls) | l == "#table" = expandAll1 r True ls
                          | l == "#endtable" = expandAll1 r False ls
                          | table = ("<tr><td><tt>" ++ nbspaces (expandRefs r l)
                                     ++ "</tt></td></tr>") : rest
                          | otherwise = (expandRefs r l) : rest
 where rest = expandAll1 r table ls

expandRefs :: Refs -> String -> String
expandRefs _ "" = ""
expandRefs r ('#':l) = expandRef r "" l
expandRefs r (c:cs) = c : expandRefs r cs

expandRef :: Refs -> String -> String -> String
expandRef r txt ('V':l) = expandVar r txt (parseRef l)
expandRef r txt ('I':l) = expandInstance r txt (parseRef l)
expandRef r txt ('T':l) = expandTycon r txt (parseRef l)
expandRef r txt ('L':l) = expandLink r txt (parseRef l)
expandRef r txt ('S':l) = expandSect r txt (parseRef l)
expandRef r _   ('&':l) = "</tt></td><td><tt>" ++ expandRefs r l
expandRef r _   ('#':l) = "#" ++ expandRefs r l
expandRef r _   ('.':l) = expandRefs r l
expandRef _ _   l = error ("Bad ref:" ++ l ++ "\n")

parseRef :: String -> (String, String)
parseRef = break (\c -> isSpace c || c == '#')

expandVar :: Refs -> String -> (String, String) -> String
expandVar r txt (v,rest) = let n = mangleVar v
                               f = lookup n r in
                             case f of
                               Nothing -> trySig r txt v rest n
                               _ -> anchor v f n txt ++ expandRefs r rest

expandTycon :: Refs -> String -> (String, String) -> String
expandTycon r txt (t,rest) = let n = mangleTycon t
                                 f = lookup n r in
                             anchor t f n txt ++ expandRefs r rest

expandInstance :: Refs -> String -> (String, String) -> String
expandInstance r txt (c,'#':rest ) = let (t,rest') = parseRef rest
                                         n = mangleInstance c t
                                         f = lookup n r in
                                       anchor c f n txt ++ expandRefs r rest'
expandInstance _ _   (_,l) = error ("bad instance " ++ l ++ "\n")

expandSect :: Refs -> String -> (String, String) -> String
expandSect r txt (s,rest) = let n = mangleSect s
                                f = lookup n r in
                              "(see " ++ anchor s f n txt ++ ")" ++
                               expandRefs r rest

expandLink :: Refs -> String -> (String, String) -> String
expandLink r _ (t,'#':l') = expandRef r t l'
expandLink _ _ (l,l') = error ("Bad link: " ++ l ++ l' ++ "\n")

trySig :: Refs -> String -> String -> String -> String -> String
trySig r txt v rest n =
   let c = parseClass rest
       n = mangleTycon c
       f = lookup n r in
     anchor v f n txt ++ expandRefs r rest

anchor :: String -> Maybe String -> String -> String -> String
anchor str mfile tag txt =
         case mfile of
           Just f -> "<a href=\"" ++ f ++ ".html#" ++ tag ++
                      "\">" ++ t ++ "</a>"
           Nothing -> "Bad tag:" ++ tag ++ " " ++ t
     where
       t = htmlS $ if txt == "" then str else txt

mangleVar :: String -> String
mangleVar n = "$v" ++ mangleName (filter (\c -> not (c `elem` "()")) n)

mangleTycon :: String -> String
mangleTycon n = "$t" ++ mangleName n

mangleInstance :: String -> String -> String
mangleInstance c t = "$i" ++ mangleName c ++ "$$" ++ mangleName t

mangleSect :: String -> String
mangleSect s = "sect" ++ s

mangleName :: String -> String
mangleName r = concatMap
                   (\c -> case c of '(' -> "$P"
                                    ')' -> "$C"
                                    '-' -> "$D"
                                    '[' -> "$B"
                                    ']' -> "$c"
                                    ',' -> "$x"
                                    '#' -> "$p"
                                    '$' -> "$D"
                                    '|' -> "$b"
                                    '!' -> "$E"
                                    '&' -> "$A"
                                    '^' -> "$U"
                                    '>' -> "$G"
                                    '<' -> "$L"
                                    '=' -> "$Q"
                                    _   -> [c]) r

mangleType :: String -> String
mangleType t = mangleName (case t of
                              "(IO"    -> "IO"
                              "(a->b)" -> "->"
                              "[a]"    -> "[]"
                              x        -> x)



readRefFile :: String -> IO [(String, String)]
readRefFile f = catchIOError
                      (do l <- readFile f
                          return (map parseKV (lines l)))
                      (\e -> do putStrLn ("Can't read ref file: " ++ f)
                                print e
                                return [])

parseKV :: String -> (String, String)
parseKV l = let (k,l1) = span (/= '=') l
                val    = case l1 of
                           ('=':v) -> trim v
                           _       -> ""
              in (trimr k,val)

parseClass :: String -> String
parseClass s = let s1 = (skip "(" . skip "::") s
                   (c,_) = span isAlpha (trim s1) in
                 c

trim :: String -> String
trim s = dropWhile isSpace s

trimr :: String -> String
trimr s = reverse (dropWhile isSpace (reverse s))

skip :: String -> String -> String
skip val s = case stripPrefix val (trim s) of
             Just s' -> s'
             Nothing -> s

htmlEncode :: Char -> String
htmlEncode '>' = "&gt;"
htmlEncode '<' = "&lt;"
htmlEncode '&' = "&amp;"
htmlEncode c   = [c]

htmlS :: String -> String
htmlS s = concatMap htmlEncode s

nbspaces :: String -> String
nbspaces "" = ""
nbspaces (' ' : cs) = "&nbsp;" ++ nbspaces cs
nbspaces ('<':cs) = ['<'] ++ c ++ nbspaces r where
                        (c,r) = span (/= '>') cs
nbspaces (c:cs) = c:nbspaces cs
