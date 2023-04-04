module BigNumber where

import Data.Char(digitToInt, intToDigit)

type BigNumber = [Int]


{-|
  Removes unnecessary zeros
-}
clearZeros :: BigNumber -> BigNumber
clearZeros [] = []
clearZeros (x:xs) = if x == 0 then clearZeros xs
                    else x:xs

{-|
  Converts a String to a BigNumber
  Converting to a negative BigNumber requires a '-' at the beginning of the string
-}
scanner :: String -> BigNumber
scanner s = clearZeros (scannerRec s)

{-|
  Auxiliary function for scanner.
-}
scannerRec:: String -> BigNumber
scannerRec [] = []
scannerRec ('-':x) = map (\a -> a*(-1))  (scannerRec x)
scannerRec (xs:x) = (digitToInt xs) : scannerRec x
{-|
  Converts a BigNumber to a String
-}
output :: BigNumber -> String
output [] = "0"
output num = if (head num) < 0 then '-': output (map (\a -> a*(-1)) num)
             else intToDigit (head num) : if length num > 1 then output (tail num) else []

{-|
  Just like haskel's init, but returns an empty list on an empty list, avoiding errors
-}
safeInit :: [a] -> [a]
safeInit [] = []
safeInit a = init a 

{-|
  Just like Haskel's last, but retuns a 0 on an empty list, avoiding errors
-}
safeLast :: [Int] -> Int
safeLast [] = 0
safeLast a = last a

{-|
  Compares the two BigNumbers, returning true if the first argument is greater or equal with it's absolute value
  Only works if both BigNumbers are the same length
-}
gteAbsBN :: BigNumber -> BigNumber -> Bool
gteAbsBN [] [] = True
gteAbsBN (x:xx) (y:yy) = if abs x > abs y then True
                        else if abs x < abs y then False
                        else gteAbsBN xx yy

{-|
  Checks if a BigNumber is negative
-}
isNegBN :: BigNumber -> Bool
isNegBN [] = False
isNegBN (x:xs) = if x < 0 then True 
                else isNegBN(xs)

{-|
  Auxiliary function to somaBN, returns true if both numbers are positive, or if the positive one is greater or equal in absolute value
-}
somaBNCheck :: BigNumber -> BigNumber -> Bool
somaBNCheck num1 num2 | isNegBN num2 == isNegBN num1 =  not (isNegBN num1)
                      | isNegBN num2 = length num1 > length num2 || length num1 == length num2 && gteAbsBN num1 num2
                      | isNegBN num1 = length num2 > length num1 || length num1 == length num2 && gteAbsBN num2 num1
                      | otherwise = True

{-|
  Performs a sum with 2 BigNumbers
-}
somaBN :: BigNumber -> BigNumber -> BigNumber 
somaBN num1 num2 = if somaBNCheck num1 num2 then clearZeros (somaBNCarry num1 num2 0)
                   else map (\a -> a*(-1)) (clearZeros (somaBNCarry (map (\a -> a*(-1)) num1) (map (\a -> a*(-1)) num2) 0))
{-|
  Auxiliary recursive function to somaBN, c is the carry value to be added to the next digit
-}
somaBNCarry :: BigNumber -> BigNumber -> Int -> BigNumber
somaBNCarry [] [] 0 = []
somaBNCarry [] [] c = [c]
somaBNCarry num1 num2 c =  somaBNCarry (safeInit num1) (safeInit num2) (div mySum 10 ) ++ [mod mySum 10]
                    where mySum = safeLast num1 + safeLast num2 + c






{-|
  Performs a subtraction between 2 BigNumbers
-}
subBN :: BigNumber -> BigNumber -> BigNumber
subBN num1 num2= somaBN num1 (map(\a -> a*(-1)) num2)

{-|
  Performs a multiplication between 2 BigNumbers
-}
mulBN :: BigNumber -> BigNumber -> BigNumber
mulBN [] [] = []
mulBN num1 [] = []
mulBN [] num2 = []
mulBN num1 num2 = somaBN (map (\a -> a * (safeLast num2)) num1) (mulBN (num1 ++ [0]) (safeInit num2))

{-|
  Adds tuples with 2 BigNumbers: addTuples (a, b) (c, d)  = (a + c, b + d)
-}
addTuples :: (BigNumber, BigNumber) -> (BigNumber, BigNumber) -> (BigNumber, BigNumber)
addTuples (a, b) (c, d) = (somaBN a c, somaBN b d)

{-|
  Auxiliary function for divBN, performs the division
  Only works with positive values
-}
divPositivosBN :: BigNumber -> BigNumber -> (BigNumber, BigNumber)
divPositivosBN [0] b = ([], [])
divPositivosBN a b | isNegBN(subBN a b) = result
          | otherwise = if fst result == [] then ([1], subBN a b)
                        else addTuples (divPositivosBN (snd result) (b)) ( mulBN [2] (fst result), [0] )
          where result = if isNegBN(subBN a b) then ([], a) 
                         else divPositivosBN a (mulBN b [2])

{-|
  Performs a map to a tuple of BigNumbers
-}
mapTuple :: (BigNumber -> BigNumber) -> (BigNumber, BigNumber) -> (BigNumber, BigNumber)
mapTuple f (a, b) = (f a, f b) 

{-|
  Performs division between 2 BigNumbers
-}
divBN :: BigNumber -> BigNumber -> (BigNumber, BigNumber)
divBN [0] b = ([], [])
divBN a b | isNegBN a && not (isNegBN b)=  mapTuple (mulBN [-1]) (divPositivosBN (mulBN [-1] a) b)
          | not (isNegBN a) && isNegBN b=  mapTuple (mulBN [-1]) (divPositivosBN a (mulBN [-1] b))
          | isNegBN a && isNegBN b=  (divPositivosBN (mulBN [-1] a) (mulBN [-1] b))
          | otherwise = divPositivosBN a b