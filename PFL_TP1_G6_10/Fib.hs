import BigNumber

fibRec :: (Integral a) => a -> a
fibRec 0 = 1
fibRec 1 = 1
fibRec n = fibRec (n-1) + fibRec (n-2) 

fibLista :: (Integral a) => a -> [a]
fibLista 0 = [1]
fibLista 1 = [1,1]
fibLista n = a ++ [last (a) + (last (init  a))]
    where a = fibLista (n - 1)

fibListaInfinita :: (Integral a) => [a]
fibListaInfinita = 1 : 1 : zipWith (+) fibListaInfinita (tail fibListaInfinita )

{-|
  Recursive Fibonnaci number, return the nth member
-}
fibRecBN ::  BigNumber -> BigNumber
fibRecBN [] = [1]
fibRecBN [1] = [1]
fibRecBN n = somaBN (fibRecBN (subBN n [1]))  (fibRecBN (subBN n [2]) )

{-|
  List of fibonacci numbers, returns the full list to the nth member
-}
fibListaBN :: BigNumber -> [BigNumber]
fibListaBN [] = [[1]]
fibListaBN [1] = [[1],[1]]
fibListaBN n = a ++ [somaBN (last (a)) (last (init  a))]
    where a = fibListaBN (subBN n [1])

{-|
  Infinite list containing the fibonnaci sequence
-}
fibListaInfinitaBN :: [BigNumber]
fibListaInfinitaBN = [1] : [1] : zipWith (somaBN) fibListaInfinitaBN (tail fibListaInfinitaBN )
