module Format
where

unescape :: String -> String
unescape = foldr step ""
  where
    step '\\' (c:cs) = case c of
      'n' -> '\n':cs
      'r' -> '\r':cs
      't' -> '\t':cs
      _   -> c:cs
    step c cs        = c:cs
