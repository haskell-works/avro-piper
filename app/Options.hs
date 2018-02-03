module Options
where

import           Data.Semigroup      ((<>))
import           Format
import           Options.Applicative

data Options = Options
  { optSchemaRegistry :: String
  , optDelimiter      :: String
  } deriving (Show)

options :: Parser Options
options = Options
  <$> strOption
        (  long "schema-registry"
        <> short 'r'
        <> metavar "URL"
        <> help "Schema registry address (http://localhost:8081)"
        )
  <*> (unescape <$> strOption
        (  long "delim"
        <> short 'D'
        <> metavar "STRING"
        <> help "Delimiter to separate messages on input"
        <> showDefault <> value "\n"
        ))

optionsParser :: ParserInfo Options
optionsParser = info (helper <*> options)
  (  fullDesc
  )

parseOptions :: IO Options
parseOptions = execParser optionsParser
