module Main where

main :: IO ()
main = do
    putStrLn "Gib input! -"
    input <- getLine
    putStrLn ("Your input: " ++ input)
